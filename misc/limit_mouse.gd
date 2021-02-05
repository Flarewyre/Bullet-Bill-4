extends Node

func _process(delta):
	if Input.get_mouse_mode() == Input.MOUSE_MODE_CONFINED:
		var viewport_size = get_viewport().size * 2
		var mouse_pos = get_viewport().get_mouse_position()
		if mouse_pos.x > viewport_size.x - 32:
			get_viewport().warp_mouse(Vector2(viewport_size.x - 32, mouse_pos.y))
