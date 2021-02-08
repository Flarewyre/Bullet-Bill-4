extends Node2D

export(Array, NodePath) var exclude_nodes

var echo_themes = [
	1,
	3
]

func _ready():
	if CurrentLevelData.level.theme in echo_themes:
		for child in get_children():
			if !(child.name in exclude_nodes):
				child.set_bus("Reverb")
