extends Node2D

const ROOM_OFFSET = Vector2(416, 234)
const EDITOR_SCENE = "res://editor.tscn"

var loaded_rooms = []
var current_room = 0

var level_cached : Level
var amount_of_rooms : int

var end = false

func _ready():
	load_level(CurrentLevelData.level)

func load_room(room, index):
	var new_room = room.duplicate()
	loaded_rooms.append(new_room)
	new_room.name = "Room_" + str(index)
	new_room.load_room()
	new_room.position.x = ROOM_OFFSET.x * index
	add_child(new_room)

func unload_room(index):
	var room_node = get_node_or_null("Room_" + str(index))
	if is_instance_valid(room_node):
		room_node.queue_free()

func load_level(level : Level):
	level_cached = level
	amount_of_rooms = level.rooms.size()
	current_room = 0
	load_room(level.rooms[0], 0)
	load_room(level.rooms[1], 1)

func _process(delta):
	if end: return
	
	OS.set_window_title(str(Engine.get_frames_per_second()))
	
	$Camera2D.position.x += 2
	if ($Camera2D.position.x - 208) > (ROOM_OFFSET.x * current_room):
		unload_room(current_room - 1)
		current_room += 1
		if amount_of_rooms > current_room:
			load_room(level_cached.rooms[current_room], current_room)
		else:
			end = true

func _input(event):
	if event.is_action_pressed("switch_modes"):
		get_tree().change_scene_to(load(EDITOR_SCENE))
