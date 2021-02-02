class_name Obstacle

var group : int
var type: int
var position : Vector2
var height: int
var flipped : bool

func determine_height(max_y : int) -> int:
	var value = int(max_y - position.y)
	if flipped:
		value = max_y - value
	return value

func return_node() -> Node:
	var types_array = preload("res://obstacles/types.tres").ids
	var scene = types_array[type].instance()
	return scene
