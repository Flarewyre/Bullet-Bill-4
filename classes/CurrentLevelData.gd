extends Node

var level : Level = Level.new()
const ROOM_SCENE_PATH = "res://room.tscn"

const theme_textures = [
	"res://obstacles/grassland/sheet.png",
	"res://obstacles/cave/sheet.png",
	"res://obstacles/underwater/sheet.png",
	"res://obstacles/castle/sheet.png",
	"res://obstacles/grassnight/sheet.png"
]

func _init():
	level.rooms.append(RoomData.new())

func _input(event):
	if !("mode" in get_tree().get_current_scene()): return
	if get_tree().get_current_scene().mode != 1: return
	
	if event.is_action_pressed("copy_level"):
		copy()

	if event.is_action_pressed("paste_level"):
		paste()

func copy():
	var data = {}
	data["theme"] = level.theme
	data["rooms"] = []
	for room in level.rooms:
		var room_data = {}
		
		room_data["obstacles"] = room.obstacles
		room_data["objects"] = room.objects
		data["rooms"].append(room_data)
	
	OS.set_clipboard(JSON.print(data))

func paste():
	var new_level = Level.new()
	var json_data = JSON.parse(OS.get_clipboard()).result
	
	new_level.theme = json_data["theme"]
	for room in json_data["rooms"]:
		var new_room = RoomData.new()
		
		for obstacle in room.obstacles:
			obstacle[0] = str2var("Vector2" + obstacle[0])

		for object in room.objects:
			object[0] = str2var("Vector2" + object[0])
		
		new_room.obstacles = room["obstacles"]
		new_room.objects = room["objects"]
		new_level.rooms.append(new_room)
	level = new_level
	
	get_tree().reload_current_scene()
