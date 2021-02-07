extends Node2D

const ROOM_OFFSET = Vector2(416, 234)
const ROOM_SCENE = "res://room.tscn"
const EDITOR_SCENE = "res://editor.tscn"

var mode := 0

onready var rooms_node = $Rooms
onready var camera = $Camera2D

var loaded_rooms := []
var current_room := 0

var level_cached : Level
var amount_of_rooms : int

var end := false
var move_camera := true
var shake_time := 0.0
var current_zoom := Vector2(1, 1)
var zoom_speed := 2.0

func _ready():
	Input.set_mouse_mode(Input.MOUSE_MODE_CONFINED)
	Input.set_custom_mouse_cursor(load("res://misc/cursor_hidden.png"))

	load_level(CurrentLevelData.level)

func load_room(room, index):
	var new_room = load(ROOM_SCENE).instance()
	loaded_rooms.append(new_room)
	new_room.name = "Room_" + str(index)
	new_room.room_index = index
	new_room.load_room()
	new_room.position.x = ROOM_OFFSET.x * index
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
	load_room(level.rooms[1], 1)

func _process(delta):
	
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
	
	if !move_camera or end: return
	camera.position.x += 8
	if (camera.position.x - 208) > (ROOM_OFFSET.x * current_room):
		unload_room(current_room - 1)
		current_room += 1
		if amount_of_rooms > current_room:
			load_room(level_cached.rooms[current_room], current_room)
		else:
			end = true
			camera.position.x = (ROOM_OFFSET.x * current_room) - 208

func _input(event):
	if event.is_action_pressed("switch_modes"):
		get_tree().change_scene_to(load(EDITOR_SCENE))
