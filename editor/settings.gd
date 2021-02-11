extends HBoxContainer

onready var animation_player = get_node("../AnimationPlayer")

func _ready():
	var _connect = $Settings.connect("pressed", self, "back")
	_connect = $Panel/Back.connect("pressed", self, "back")

func back():
	animation_player.play("close_" + name)

