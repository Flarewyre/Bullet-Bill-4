extends VBoxContainer

onready var room_left = $RoomLeft
onready var room_right = $RoomRight

func _ready():
	var _connect = room_left.connect("pressed", self, "move_room", [1])
	_connect = room_right.connect("pressed", self, "move_room", [-1])

func move_room(swap_direction):
	get_tree().get_current_scene().move_room(swap_direction)
