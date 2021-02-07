extends HBoxContainer

onready var animation_player = get_node("../AnimationPlayer")

func _ready():
	var _connect
	for child in get_children():
		_connect = child.connect("pressed", self, "button_pressed", [child.name])

func button_pressed(button_name):
	animation_player.play("open_" + button_name)
