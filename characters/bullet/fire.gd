extends AudioStreamPlayer

onready var sprite = get_node("../../AnimatedSprite")

func _process(delta):
	var won = get_tree().get_current_scene().won
	volume_db = lerp(volume_db, -22 if !won else -80, delta)
	
	pitch_scale = (((abs(sprite.rotation_degrees) / 35) * -sign(sprite.rotation_degrees)) / 3)  + 1
