extends Node

var level : Level = Level.new()
const ROOM_SCENE_PATH = "res://room.tscn"

func _init():
	for index in range(5):
		level.rooms.append(load(ROOM_SCENE_PATH).instance())
