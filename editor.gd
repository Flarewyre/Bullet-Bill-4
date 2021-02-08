extends Node2D

const PLAYER_SCENE = "res://level_loader.tscn"
const ROOM_SCENE = "res://room.tscn"
const ROOM_WIDTH = 416
const TYPE_WIDTHS = [
	16,
	32,
	48,
	64
]

var mode := 1

onready var viewport_node = $Viewport
onready var viewport_texture = $Screen
onready var rooms_node = $Viewport/Rooms
onready var previews_node = $Viewport/Previews
onready var delete_area = $Viewport/DeleteArea
onready var backgrounds = $Viewport/Backgrounds
onready var overlays = $Viewport/Overlays

onready var screen_detect_area = $ScreenDetectArea

var current_room = 0
var current_room_node : Node2D
var last_room_node : Node2D

var flipped := false
var terrain_type := 0

var preview_disabled := false
var selecting_obstacle := true

var can_interact := true
var swap_direction := 0

func _ready():
	Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE)
	Input.set_custom_mouse_cursor(load("res://misc/cursor_normal.png"))

	for preview in previews_node.get_children():
		if preview.name != "Bricks":
			preview.texture = load(CurrentLevelData.theme_textures[CurrentLevelData.level.theme])
		else:
			preview.texture = load(preview.ids[CurrentLevelData.level.theme])

	swap_rooms(current_room)

func swap_rooms(index):
	unload_room(index)
	
	current_room_node = load(ROOM_SCENE).instance()
	
	load_room(current_room_node, index)

func unload_room(index):
	var room_node = rooms_node.get_node_or_null("Room_" + str(index))
	if is_instance_valid(room_node):
		room_node.queue_free()

func load_room(room, index):
	room.name = "Room_" + str(index)
	room.room_index = index
	room.load_room()
	rooms_node.add_child(room)

func mouse_position():
	return (get_global_mouse_position() - viewport_texture.rect_position) / 3

func place_obstacle(obj_position : Vector2, type : int, is_flipped : bool):
	CurrentLevelData.level.rooms[current_room].obstacles.append([obj_position, type, is_flipped])
	current_room_node.load_room()
	
func delete_obstacle(index : int):
	CurrentLevelData.level.rooms[current_room].obstacles.remove(index)
	current_room_node.load_room()

func place_object(obj_position : Vector2, type : int):
	CurrentLevelData.level.rooms[current_room].objects.append([obj_position, type])
	current_room_node.load_room()

func delete_object(index : int):
	CurrentLevelData.level.rooms[current_room].objects.remove(index)
	current_room_node.load_room()

func _input(event):
	if !can_interact: return
	
	if event is InputEventMouseButton:
		if event.button_index == BUTTON_LEFT and event.pressed and !preview_disabled:
			if selecting_obstacle:
				var obstacle_pos = Vector2(
					round(mouse_position().x / 16),
					round(mouse_position().y / 16)
				)
				obstacle_pos = correct_mouse_pos(obstacle_pos)
				place_obstacle(obstacle_pos, terrain_type, flipped)
			
	elif event.is_action_pressed("switch_modes"):
		remove_child(current_room_node)
		get_tree().change_scene_to(load(PLAYER_SCENE))
		
	elif event.is_action_pressed("flip"):
		flipped = !flipped

	elif event.is_action_pressed("type_0"):
		terrain_type = 0
		selecting_obstacle = true

	elif event.is_action_pressed("type_1"):
		terrain_type = 1
		selecting_obstacle = true

	elif event.is_action_pressed("type_2"):
		terrain_type = 2
		selecting_obstacle = true

	elif event.is_action_pressed("type_3"):
		terrain_type = 3
		selecting_obstacle = true

	elif event.is_action_pressed("bricks"):
		terrain_type = 0
		selecting_obstacle = false
	
	elif event.is_action_pressed("room_left"):
		if current_room - 1 >= 0:
			current_room -= 1
			last_room_node = current_room_node
			current_room_node = load(ROOM_SCENE).instance()
			current_room_node.position.x = -ROOM_WIDTH
			can_interact = false
			swap_direction = 1
			load_room(current_room_node, current_room)
	
	elif event.is_action_pressed("room_right"):
		if current_room + 1 < CurrentLevelData.level.rooms.size():
			current_room += 1
			last_room_node = current_room_node
			current_room_node = load(ROOM_SCENE).instance()
			current_room_node.position.x = ROOM_WIDTH
			can_interact = false
			swap_direction = -1
			load_room(current_room_node, current_room)
	
	elif event.is_action_pressed("change_theme"):
		CurrentLevelData.level.theme = wrapi(CurrentLevelData.level.theme + 1, 0, CurrentLevelData.theme_textures.size())
		current_room_node.load_room()
		backgrounds.change_texture()
		overlays.change_overlay()
		
		for preview in previews_node.get_children():
			if preview.name != "Bricks":
				preview.texture = load(CurrentLevelData.theme_textures[CurrentLevelData.level.theme])
			else:
				preview.texture = load(preview.ids[CurrentLevelData.level.theme])

func correct_mouse_pos(mouse_pos : Vector2):
	if mouse_pos.x < 0:
		mouse_pos.x = 0
	
	if (mouse_pos.x * 16) + TYPE_WIDTHS[terrain_type] > 416:
		mouse_pos.x = (416 - TYPE_WIDTHS[terrain_type]) / 16

	if mouse_pos.y < 0:
		mouse_pos.y = 0
	
	if mouse_pos.y * 16 > 232:
		mouse_pos.y = 232 / 16
	
	return mouse_pos

func _process(delta):
	var preview_node
	
	if swap_direction != 0:
		var speed = 3
		last_room_node.position.x = lerp(last_room_node.position.x, (ROOM_WIDTH * swap_direction) + (swap_direction * 10), delta * speed)
		current_room_node.position.x = last_room_node.position.x + (ROOM_WIDTH * -swap_direction) 
		
		if (
			(swap_direction == -1 and current_room_node.position.x <= 0)
			or (swap_direction == 1 and current_room_node.position.x >= 0)
		):
			current_room_node.position.x = 0
			swap_direction = 0
			can_interact = true
			unload_room(last_room_node.room_index)

	screen_detect_area.position = get_viewport().get_mouse_position()
	if screen_detect_area.get_overlapping_areas().size() > 0 and swap_direction == 0:
		can_interact = true
	else:
		can_interact = false
	
	if !can_interact:
		for preview in previews_node.get_children():
			preview.visible = false
		return
	
	for preview in previews_node.get_children():
		var match_name = "Type" + str(terrain_type)
		if !selecting_obstacle:
			match_name = "Bricks"
		
		if preview.name == match_name:
			preview.visible = true
			preview_node = preview
		else:
			preview.visible = false
	
	var obstacle_pos = Vector2(
		round(mouse_position().x / 16),
		round(mouse_position().y / 16)
	)
	obstacle_pos = correct_mouse_pos(obstacle_pos)
	
	preview_disabled = false
	if selecting_obstacle:
		var obj_index = 0
		for obstacle in CurrentLevelData.level.rooms[current_room].obstacles:
			if (
				(obstacle[2] == flipped or 
					(((obstacle_pos.y + 1) > obstacle[0].y and flipped) or (obstacle_pos.y - 1) < obstacle[0].y and !flipped))
			):			
				for index in range(terrain_type + 1):
					if (obstacle_pos.x + index == obstacle[0].x):
						preview_disabled = true
						
				for index in range(obstacle[1] + 1):
					if (obstacle_pos.x - index == obstacle[0].x):
						preview_disabled = true
			obj_index += 1
	
	if preview_disabled:
		preview_node.modulate = Color(1, 0.25, 0.25, 0.5)
	else:
		preview_node.modulate = Color(1, 1, 1, 0.5)
	preview_node.position = obstacle_pos * 16
	
	if selecting_obstacle:
		preview_node.scale.y = 1 if !flipped else -1
		if flipped:
			preview_node.position.y += 16
	
	delete_area.position = mouse_position()
	if Input.is_action_just_pressed("delete_obstacle"):
		for obstacle in delete_area.get_overlapping_bodies():
			if obstacle.get_parent().has_method("is_obstacle"):
				delete_obstacle(obstacle.get_parent().index)
		
	if Input.is_action_pressed("delete_obstacle"):
		for obstacle in delete_area.get_overlapping_bodies():
			if !obstacle.get_parent().has_method("is_obstacle"):
				delete_object(obstacle.get_parent().index)
				
		for obstacle in delete_area.get_overlapping_areas():
			if !obstacle.get_parent().has_method("is_obstacle"):
				delete_object(obstacle.get_parent().index)

	if !selecting_obstacle and Input.is_action_pressed("place_obstacle"):
		var can_place = true
		
		for object in current_room_node.get_node("Objects").get_children():
			if object.position == obstacle_pos * 16:
				can_place = false
		
		if can_place:
			place_object(obstacle_pos, 0)
