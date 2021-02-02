extends Node2D

func set_height(height):
	var sprite = $NinePatchRect
	var collision = $StaticBody2D/CollisionShape2D
	
	var new_shape = collision.shape.duplicate()
	new_shape.extents.y = (height * 8) + 16
	
	collision.shape = new_shape
	collision.position = new_shape.extents

	sprite.rect_size.y = (height * 16) + 32

func flip():
	var sprite = $NinePatchRect

	scale.y = -scale.y
	position.y += 16
