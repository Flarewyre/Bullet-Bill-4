extends Label

func _process(delta):
	text = "L - " + str(CurrentLevelData.level.rooms.size())
