extends Node2D

func transition():
	var animation_player = $AnimationPlayer
	animation_player.play("in")
	yield(animation_player, "animation_finished")
	animation_player.play("out")
