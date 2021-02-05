extends Node2D

export var reaction_speed := 0.0

var middle_pos : Vector2
var dead := false

onready var timer = $Timer
onready var area = $Area2D
onready var animation_player = $AnimationPlayer

func _ready():
	var _connect = timer.connect("timeout", self, "restart")
	_connect = area.connect("body_entered", self, "kill")
	middle_pos = Vector2(208, 117)

func _physics_process(delta):
	if dead: return


	position = lerp(position, get_global_mouse_position(), delta * reaction_speed)

func kill(body):
	dead = true
	get_tree().get_current_scene().move_camera = false
	get_tree().get_current_scene().shake_time = 0.5
	animation_player.play("die")

func restart():
	get_tree().reload_current_scene()
