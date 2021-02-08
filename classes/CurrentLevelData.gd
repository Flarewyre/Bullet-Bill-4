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
	for index in range(25):
		level.rooms.append(RoomData.new())
