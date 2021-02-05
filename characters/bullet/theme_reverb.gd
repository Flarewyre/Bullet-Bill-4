extends Node2D

export(Array, NodePath) var exclude_nodes

func _ready():
	if CurrentLevelData.level.theme == 1:
		for child in get_children():
			if !(child.name in exclude_nodes):
				child.set_bus("Reverb")
