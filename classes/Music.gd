extends AudioStreamPlayer

const EDITOR_MUSIC := "res://music/editor.ogg"
const LEVEL_THEMES := [
	"res://music/level_themes/overworld.ogg",
	"res://music/level_themes/underground.ogg"
]

var last_mode := 0

func _process(delta):
	var current_mode = -1
	if "mode" in get_tree().get_current_scene():
		current_mode = get_tree().get_current_scene().mode
	
	if current_mode != last_mode:
		if current_mode == 1:
			stream = load(EDITOR_MUSIC)
			play()
		else:
			stream = load(LEVEL_THEMES[CurrentLevelData.level.theme])
			play()
			
	last_mode = current_mode
