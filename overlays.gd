extends CanvasLayer

onready var water_tint = $WaterTint
onready var lava_tint = $LavaTint
onready var night_effect = $NightEffect
onready var night_effect_2 = $NightEffect2
onready var cave_effect = $CaveEffect

onready var dizzy = $DizzyEffect

var theme_overlays : Array

func _ready():
	theme_overlays = [
		[],
		[cave_effect],
		[water_tint],
		[lava_tint],
		[night_effect, night_effect_2]
	]
	change_overlay()

func change_overlay():
	for child in get_children():
		if child in theme_overlays[CurrentLevelData.level.theme]:
			child.visible = true
		else:
			child.visible = false
