extends Node2D

export var reaction_speed := 0.0

var middle_pos : Vector2
var dead := false

var brick_combo = 0
var combo_reset_timer = 0.0

onready var timer = $Timer
onready var area = $Area2D
onready var animation_player = $AnimationPlayer

onready var brick_sound = $Sounds/Brick
onready var camera = get_node("../Camera2D")

var last_camera_pos : Vector2

func is_character():
	pass

func _ready():
	var _connect = timer.connect("timeout", self, "restart")
	_connect = area.connect("body_entered", self, "kill")
	middle_pos = Vector2(208, 117)

func _physics_process(delta):
	if dead: return
	
	if combo_reset_timer > 0:
		combo_reset_timer -= delta
		if combo_reset_timer <= 0:
			combo_reset_timer = 0
			brick_combo = 0
	
	var current_camera_pos = camera.position + camera.offset
	position = lerp(position, get_global_mouse_position() + ((current_camera_pos - last_camera_pos) * 4), delta * reaction_speed)
	last_camera_pos = current_camera_pos

func kill(body):
	dead = true
	get_tree().get_current_scene().move_camera = false
	get_tree().get_current_scene().shake_time = 0.5
	animation_player.play("die")

func restart():
	get_tree().reload_current_scene()

func brick_sound():
	brick_sound.pitch_scale = 1.0 + rand_range(-0.1, 0.1)
	brick_sound.play()

func break_effect():
	combo_reset_timer = 0.35
	brick_combo = clamp(brick_combo + 1, 0, 8)
	
	get_tree().get_current_scene().shake_time = 0.125 + (float(brick_combo) / 150.0)
	var zoom_amount = 0.94 - (float(brick_combo) / 75.0)
	get_tree().get_current_scene().current_zoom = Vector2(zoom_amount, zoom_amount)
