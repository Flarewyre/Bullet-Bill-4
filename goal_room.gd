extends Node2D

onready var tape = $Tape
onready var sprite = $Tape/Sprite
onready var particles = $Tape/CPUParticles2D
onready var area = $Tape/Area2D
onready var area2 = $Area2D
onready var audio = $Tape/AudioStreamPlayer

var direction = 1

var broken = false
var end = false

func _ready():
	var _connect = area.connect("area_entered", self, "win", [true])
	_connect = area2.connect("area_entered", self, "win", [false])

func _physics_process(delta):
	if !broken:
		tape.position.y += 2 * direction

		if tape.position.y < 24 or tape.position.y > 231:
			direction = -direction

func win(body, is_tape):
	if end: return
	end = true
	
	if is_tape:
		broken = true
		sprite.visible = false
		particles.emitting = true
		audio.play()

	get_tree().get_current_scene().win(is_tape)
