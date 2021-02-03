extends Node2D

const PLAYER_SCENE = "res://level_loader.tscn"
onready var rooms_node = $Rooms
onready var previews_node = $Previews

var current_room = 0
var current_room_node : Node2D

var flipped := false
var terrain_type := 0

func _ready():
	swap_rooms(current_room)

func swap_rooms(index):
	unload_room(index)
	current_room_node = CurrentLevelData.level.rooms[index].duplicate()
	load_room(current_room_node, index)

func unload_room(index):
	var room_node = rooms_node.get_node_or_null("Room_" + str(index))
	if is_instance_valid(room_node):
		room_node.queue_free()

func load_room(room, index):
	room.name = "Room_" + str(index)
	room.load_room()
	rooms_node.add_child(room)

func place_obstacle(obj_position : Vector2, type : int, is_flipped : bool):
	current_room_node.obstacle_data.append([obj_position, type, is_flipped])
	current_room_node.load_room()
	
	CurrentLevelData.level.rooms[current_room].obstacle_data = current_room_node.obstacle_data.duplicate(true)

func _input(event):
	if event is InputEventMouseButton:
		if event.button_index == BUTTON_LEFT and event.pressed:
			var obstacle_pos = Vector2(
				round(get_global_mouse_position().x / 16),
				round(get_global_mouse_position().y / 16)
			)
			for obstacle in current_room_node.obstacle_data:
				if obstacle[0].x == obstacle_pos.x:
					current_room_node.obstacle_data.erase(obstacle)
			place_obstacle(obstacle_pos, terrain_type, flipped)
			
	elif event.is_action_pressed("switch_modes"):
		CurrentLevelData.level.rooms.clear()
		for index in range(25):
			CurrentLevelData.level.rooms.append(current_room_node.duplicate())
		get_tree().change_scene_to(load(PLAYER_SCENE))
		
	elif event.is_action_pressed("flip"):
		flipped = !flipped

	elif event.is_action_pressed("type_0"):
		terrain_type = 0

	elif event.is_action_pressed("type_1"):
		terrain_type = 1

	elif event.is_action_pressed("type_2"):
		terrain_type = 2

	elif event.is_action_pressed("type_3"):
		terrain_type = 3

func _process(delta):
	var preview_node
	for preview in previews_node.get_children():
		if preview.name == "Type" + str(terrain_type):
			preview.visible = true
			preview_node = preview
		else:
			preview.visible = false
	
	var obstacle_pos = Vector2(
		round(get_global_mouse_position().x / 16),
		round(get_global_mouse_position().y / 16)
	)
	
	preview_node.rect_scale.y = 1 if !flipped else -1
	preview_node.rect_position = obstacle_pos * 16
	
	if flipped:
		preview_node.rect_position.y += 16
