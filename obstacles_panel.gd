extends TextureRect

onready var type_0 = $HBoxContainer/Type0
onready var type_1 = $HBoxContainer/Type1
onready var type_2 = $HBoxContainer/Type2
onready var type_3 = $HBoxContainer/Type3

onready var flip = $Flip
onready var hbox_container = $HBoxContainer

onready var editor = get_tree().get_current_scene()
onready var animation_player = editor.get_node("AnimationPlayer")

var buttons = []
var level_theme := 0

func _ready():
	var _connect = flip.connect("pressed", self, "flip")
	buttons = [
		type_0,
		type_1,
		type_2,
		type_3
	]
	
	for button in buttons:
		_connect = button.connect("pressed", self, "select_obstacle", [button.name[4]])

func select_obstacle(id):
	editor.terrain_type = id
	editor.selecting_obstacle = true

func _process(delta):
	if get_parent().visible and (
		(hbox_container.rect_scale.y == 1 and editor.flipped)
		or (hbox_container.rect_scale.y == -1 and !editor.flipped)
	):
		editor.flipped = !editor.flipped
		flip()
	
	if level_theme != CurrentLevelData.level.theme:
		level_theme = CurrentLevelData.level.theme
		for button in buttons:
			button.get_node("Sprite").texture = load(CurrentLevelData.theme_textures[level_theme])

	var index = 0
	for button in buttons:
		var sprite = button.get_node("Sprite")
		var is_selected = (editor.selecting_obstacle and editor.terrain_type == index)
		
		if !is_selected:
			if button.is_hovered():
				sprite.position.y = lerp(sprite.position.y, 0, delta * 16)
			else:
				sprite.position.y = lerp(sprite.position.y, 17, delta * 16)
		else:
			sprite.position.y = lerp(sprite.position.y, 48, delta * 8)
		index += 1

func flip():
	editor.flipped = !editor.flipped
	animation_player.play("flip_Obstacles")

func flip_sprites():
	hbox_container.rect_scale.y = -1 if editor.flipped else 1
	if hbox_container.rect_scale.y < 0:
		hbox_container.rect_position.y = 95
	else:
		hbox_container.rect_position.y = 0
