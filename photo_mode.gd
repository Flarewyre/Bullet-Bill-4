extends Camera2D

func _physics_process(delta):
	if Input.is_action_just_pressed("photo_mode"):
		get_tree().paused = !get_tree().paused
