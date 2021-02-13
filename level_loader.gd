extends Node2D

const ROOM_OFFSET = Vector2(416, 234)
const ROOM_SCENE = "res://room.tscn"
const GOAL_SCENE = "res://goal_room.tscn"
const EDITOR_SCENE = "res://editor.tscn"

var mode := 0

onready var rooms_node = $Rooms
onready var camera = $Camera2D
onready var animation_player = $AnimationPlayer

onready var platform = $Intro/Platform

var loaded_rooms := []
var room_positions := []
var current_room := 0

var path_points := []

var level_cached : Level
var amount_of_rooms : int

var end := false
export var move_camera := false
export var shake_time := 0.0
export var shake_multiplier := 1.0
var current_zoom := Vector2(1, 1)
var zoom_speed := 2.0

var won := false

var next_point_index := 0
var move_normal : Vector2
var target : Vector2
var move_speed := 8.0
var path_index := 0
var current_rot := 0.0
var current_speed := 0.0

var last_room_pos : Vector2

func _ready():
	current_speed = move_speed
	
	Input.set_mouse_mode(Input.MOUSE_MODE_CONFINED)
	Input.set_custom_mouse_cursor(load("res://misc/cursor_hidden.png"))

	load_level(CurrentLevelData.level)
	animation_player.play("start")
	platform.texture = load(CurrentLevelData.theme_textures[CurrentLevelData.level.theme])
	shake_time = 0
	shake_multiplier = 1

func win(hit_tape):
	won = true
	Music.play_win_music(hit_tape)
	
	if hit_tape:
		yield(get_tree().create_timer(1), "timeout")
		animation_player.play("fireworks")
		yield(get_tree().create_timer(2.25), "timeout")
		animation_player.play("fireworks2")
		yield(get_tree().create_timer(2.25), "timeout")
		animation_player.play("fireworks3")

func load_room(room, index, room_rotation = 0, room_position = Vector2(-1, -1)):
	var new_room = load(ROOM_SCENE).instance()
	loaded_rooms.append(new_room)
	new_room.name = "Room_" + str(index)
	new_room.room_index = index
	new_room.rotation_degrees = room_rotation
	new_room.load_room()
	
	new_room.position = (last_room_pos + Vector2(ROOM_OFFSET.x, 0)) if room_position == Vector2(-1, -1) else room_position
	rooms_node.add_child(new_room)

func unload_room(index):
	var room_node = rooms_node.get_node_or_null("Room_" + str(index))
	if is_instance_valid(room_node):
		room_node.queue_free()

func load_level(level : Level):
	level_cached = level
	amount_of_rooms = level.rooms.size()
	current_room = 0
	
	var curve = Curve2D.new()
	
	var room_pos = Vector2(0, 0)
	var index = 0
	var current_rot = 0
	for room in level.rooms:
		# below was for testing
		
		#if index == 5:
		#	curve.add_point(room_pos + Vector2(117, 117))
		#	current_rot = -90
			
		#if index == 9:
		#	curve.add_point(room_pos + Vector2(117, -117))
		#	current_rot = -180
			
		#if index == 16:
		#	curve.add_point(room_pos + Vector2(-117, -117))
		#	current_rot = -270
			
		var angle = deg2rad(current_rot)
		var normal = Vector2(cos(angle), sin(angle))
		room_positions.append([room_pos, current_rot])
		curve.add_point(room_pos + Vector2(208, 117).rotated(angle))
		room_pos += ROOM_OFFSET.x * normal
		index += 1
	
	$Path2D.curve = curve
	curve.bake_interval = 32
	path_points = $Path2D.curve.get_baked_points()
	
	target = path_points[0]
	move_normal = (target - camera.position).normalized()

func calculate_camera_angle(last_target):
	var dx = target.x - last_target.x
	var dy = target.y - last_target.y
	var x_normal = Vector2(-dy, dx)
	var y_normal = Vector2(dy, -dx)
	return y_normal.angle() + PI/2

func angle_difference(angle1, angle2):
	var diff = angle2 - angle1
	return diff if abs(diff) < 180 else diff + (360 * -sign(diff))

func _physics_process(delta):
	
	OS.set_window_title(str(Engine.get_frames_per_second()))
	
	if shake_time > 0:
		shake_time -= delta
		var multiplier = (shake_time / 0.075) * shake_multiplier
		# shake_rotation = rand_range(-1, 1) * multiplier -- too much juice
		camera.offset = Vector2(rand_range(-1, 1)  * multiplier, rand_range(-1, 1) * multiplier)
	else:
		camera.offset = Vector2()
	
	camera.zoom = current_zoom / 4
	current_zoom = lerp(current_zoom, Vector2(1, 1), delta * zoom_speed)

	if !move_camera: return

	if camera.position.distance_to(target) < (current_speed * 2.5) and path_index + 1 < path_points.size():
		path_index += 1
		target = path_points[path_index]
		move_normal = (target - camera.position).normalized()
		current_rot = calculate_camera_angle(path_points[path_index - 1])
	
	camera.rotation = lerp_angle(camera.rotation, current_rot, delta * 5)
	camera.position += move_normal * current_speed
	
	if abs(angle_difference(camera.rotation_degrees, rad2deg(current_rot))) < 5:
		current_speed = lerp(current_speed, move_speed, delta * 6)
	else:
		current_speed = lerp(current_speed, move_speed / 2, delta * 6)
	
	if end: return
	
	var extra_pos = Vector2(208, -117).rotated(current_rot)
	if (camera.position + extra_pos).distance_to(room_positions[current_room][0]) < (current_speed * 2.5):
		load_room(CurrentLevelData.level.rooms[current_room], current_room, room_positions[current_room][1], room_positions[current_room][0])
		if current_room >= 3:
			unload_room(current_room - 3)
		
		if current_room + 1 >= room_positions.size():
			end = true
			var goal_room = load(GOAL_SCENE).instance()
			var angle = deg2rad(room_positions[current_room][1])
			var normal = Vector2(cos(angle), sin(angle))
			
			goal_room.position = room_positions[current_room][0] + (ROOM_OFFSET.x * normal)
			goal_room.rotation = angle
			rooms_node.add_child(goal_room)
		else:
			current_room += 1

func _input(event):
	if event.is_action_pressed("switch_modes") and !SceneTransitions.transitioning:
		SceneTransitions.transition()
		yield(get_tree().create_timer(SceneTransitions.transition_time), "timeout")
		get_tree().change_scene_to(load(EDITOR_SCENE))
