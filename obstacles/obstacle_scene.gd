extends Node2D

var index = 0

func is_obstacle():
	return true

func set_height(height):
	var sprite = $Sprite
	var collision = $StaticBody2D/CollisionShape2D
	
	var new_shape = collision.shape.duplicate()
	new_shape.extents.y = (height * 8) + 16
	
	collision.shape = new_shape
	collision.position = new_shape.extents

	sprite.region_rect.size.y = (height * 16) + 32

func flip():
	scale.y = -scale.y
	position.y += 16

func set_theme(theme):
	$Sprite.texture = load(CurrentLevelData.theme_textures[theme])
