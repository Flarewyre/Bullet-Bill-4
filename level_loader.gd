extends Node2D

const ROOM_OFFSET = Vector2(416, 234)

func _ready():
	load_level(CurrentLevelData.level)

func load_level(level : Level):
	var index = 0
	for room in level.rooms:
		room.name = "Room_" + str(index)
		room.load_room()
		room.position.x = ROOM_OFFSET.x * index
		add_child(room)
		index += 1

func _process(delta):
	$Camera2D.position.x += 2
