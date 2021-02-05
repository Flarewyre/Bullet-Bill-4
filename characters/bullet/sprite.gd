extends AnimatedSprite

export var rotation_speed := 0.0
export var rot_multiplier := 0.0
var stored_frame := 0.0

func _physics_process(delta):
	var screen_pos = get_global_transform_with_canvas().origin
	rotation_degrees = lerp(rotation_degrees, clamp((get_viewport().get_mouse_position().y - screen_pos.y) / 1.5, -35, 35), delta * rotation_speed)
	
	if rotation_degrees < -5:
		stored_frame = lerp(stored_frame, 8, delta * rot_multiplier)
		frame = stepify(stored_frame, 1)
	elif rotation_degrees < 5:
		stored_frame = lerp(stored_frame, 4, delta * rot_multiplier)
		frame = stepify(stored_frame, 1)
	else:
		stored_frame = lerp(stored_frame, 0, delta * rot_multiplier)
		frame = stepify(stored_frame, 1)
