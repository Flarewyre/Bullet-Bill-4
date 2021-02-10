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
var current_room := 0

var level_cached : Level
var amount_of_rooms : int

var end := false
export var move_camera := false
export var shake_time := 0.0
var current_zoom := Vector2(1, 1)
var zoom_speed := 2.0

var won := false

var last_room_pos : Vector2

func _ready():
	Input.set_mouse_mode(Input.MOUSE_MODE_CONFINED)
	Input.set_custom_mouse_cursor(load("res://misc/cursor_hidden.png"))

	load_level(CurrentLevelData.level)
	animation_player.play("start")
	platform.texture = load(CurrentLevelData.theme_textures[CurrentLevelData.level.theme])
	shake_time = 0

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

func load_room(room, index, room_rotation = 0):
	var new_room = load(ROOM_SCENE).instance()
	loaded_rooms.append(new_room)
	new_room.name = "Room_" + str(index)
	new_room.room_index = index
	new_room.rotation_degrees = room_rotation
	new_room.load_room()
	
	new_room.position = (last_room_pos + Vector2(ROOM_OFFSET.x, 0))
	rooms_node.add_child(new_room)

func unload_room(index):
	var room_node = rooms_node.get_node_or_null("Room_" + str(index))
	if is_instance_valid(room_node):
		room_node.queue_free()

func load_level(level : Level):
	level_cached = level
	amount_of_rooms = level.rooms.size()
	current_room = 0
	load_room(level.rooms[0], 0)

func _physics_process(delta):
	
	OS.set_window_title(str(Engine.get_frames_per_second()))
	
	if shake_time > 0:
		shake_time -= delta
		var multiplier = shake_time / 0.075
		# shake_rotation = rand_range(-1, 1) * multiplier -- too much juice
		camera.offset = Vector2(rand_range(-1, 1)  * multiplier, rand_range(-1, 1) * multiplier)
	else:
		camera.offset = Vector2()
	
	camera.zoom = current_zoom / 4
	current_zoom = lerp(current_zoom, Vector2(1, 1), delta * zoom_speed)
	
	if !move_camera: return
	camera.position.x += 8
	
	if end: return
	if (camera.position.x - 208) > last_room_pos.x + ROOM_OFFSET.x:
		unload_room(current_room - 1)
		current_room += 1
		if amount_of_rooms > current_room:
			last_room_pos = last_room_pos + Vector2(ROOM_OFFSET.x, 0)
			load_room(level_cached.rooms[current_room], current_room, 0)
		else:
			end = true
			var goal_room = load(GOAL_SCENE).instance()
			goal_room.position = last_room_pos + Vector2(ROOM_OFFSET.x * 3, 0)
			rooms_node.add_child(goal_room)

func _input(event):
	if event.is_action_pressed("switch_modes") and !SceneTransitions.transitioning:
		SceneTransitions.transition()
		yield(get_tree().create_timer(SceneTransitions.transition_time), "timeout")
		get_tree().change_scene_to(load(EDITOR_SCENE))
