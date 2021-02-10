extends AudioStreamPlayer

onready var win_music_player = $WinMusic

const EDITOR_MUSIC := "res://music/editor.ogg"
const WIN_MUSIC := "res://music/win.ogg"
const WIN_MUSIC_2 := "res://music/win_2.ogg"
const LEVEL_THEMES := [
	"res://music/level_themes/overworld.ogg",
	"res://music/level_themes/underground.ogg",
	"res://music/level_themes/underwater.ogg",
	"res://music/level_themes/castle.ogg",
	"res://music/level_themes/night.ogg"
]

var last_mode := 0
var lerp_win_music = false

var time := 0.0

func _process(delta):
	time += delta
	#for touching fuzzy
	#pitch_scale = 1 + (sin(time * 4) / 10)
	
	var current_mode = -1
	if "mode" in get_tree().get_current_scene():
		current_mode = get_tree().get_current_scene().mode
	
	if current_mode != last_mode:
		lerp_win_music = false
		volume_db = 0
		win_music_player.volume_db = -80
		win_music_player.stop()
		
		if current_mode == 1:
			stream = load(EDITOR_MUSIC)
			play()
		else:
			stream = load(LEVEL_THEMES[CurrentLevelData.level.theme])
			play()
			
	last_mode = current_mode
	
	if lerp_win_music:
		volume_db = lerp(volume_db, -80, delta / 2)
		win_music_player.volume_db = lerp(win_music_player.volume_db, 0, delta * 4)

func play_win_music(hit_tape):
	win_music_player.stream = load(WIN_MUSIC) if hit_tape else load(WIN_MUSIC_2)
	win_music_player.play()

	if hit_tape:
		win_music_player.volume_db = 0
		volume_db = -80
	else:
		lerp_win_music = true
