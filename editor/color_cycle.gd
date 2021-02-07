extends TextureRect

func _process(delta):
	texture.gradient.colors[0].h += 0.0001
	texture.gradient.colors[1].h += 0.0001
