extends Node2D

onready var area = $Area2D
onready var anim_player = $AnimationPlayer

var index = 0

const THEME_FRAMES = [
	"res://objects/bricks/textures/grassland/frames.tres",
	"res://objects/bricks/textures/cave/frames.tres",
	"res://objects/bricks/textures/underwater/frames.tres",
	"res://objects/bricks/textures/castle/frames.tres",
	"res://objects/bricks/textures/grassland/frames.tres"
]

const THEME_FX = [
	"res://objects/bricks/textures/grassland/brick_fx.png",
	"res://objects/bricks/textures/cave/brick_fx.png",
	"res://objects/bricks/textures/underwater/brick_fx.png",
	"res://objects/bricks/textures/castle/brick_fx.png",
	"res://objects/bricks/textures/grassland/brick_fx.png"
]

var broken := false

func _ready():
	area.connect("area_entered", self, "destroy")
	
	$AnimatedSprite.frames = load(THEME_FRAMES[CurrentLevelData.level.theme])
	$BreakParticles.texture = load(THEME_FX[CurrentLevelData.level.theme])

func destroy(body):
	if broken or !body.get_parent().has_method("is_character"): return
	
	broken = true
	var body_parent = body.get_parent()
	body_parent.brick_sound()
	body_parent.break_effect()
	anim_player.play("break")

func despawn():
	queue_free()
