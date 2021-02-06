extends CanvasLayer

const THEME_BGS = [
	"res://backgrounds/clouds/texture.png",
	"res://backgrounds/cave/texture.png"
]

const THEME_REPEATS = [
	512,
	512
]

onready var camera = get_node("../Camera2D")
onready var sprite = $Sprite
onready var sprite_2 = $Sprite2

var last_position : Vector2

export var x_repeat : int

func _ready():
	change_texture()
	
	sprite_2.position.x = x_repeat * 4

func change_texture():
	sprite.texture = load(THEME_BGS[CurrentLevelData.level.theme])
	sprite_2.texture = load(THEME_BGS[CurrentLevelData.level.theme])
	x_repeat = THEME_REPEATS[CurrentLevelData.level.theme]

func _process(delta):
	var current_position = camera.position + camera.offset
	var increment = (current_position.x - last_position.x) / 4
	
	sprite.position.x -= increment
	sprite_2.position.x -= increment
	if sprite_2.position.x <= 0:
		sprite.position.x = 0
		sprite_2.position.x = x_repeat * 4
		
	last_position = current_position
