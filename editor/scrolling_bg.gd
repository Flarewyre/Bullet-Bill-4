extends TextureRect

func _process(delta):
	rect_position += Vector2(1, 1)
	if rect_position.x >= 0:
		rect_position = Vector2(-32, -32)
