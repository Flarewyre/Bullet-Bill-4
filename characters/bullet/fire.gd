extends AudioStreamPlayer

onready var sprite = get_node("../../AnimatedSprite")

func _process(delta):
	pitch_scale = (((abs(sprite.rotation_degrees) / 35) * -sign(sprite.rotation_degrees)) / 3)  + 1
