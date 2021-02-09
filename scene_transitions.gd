extends Node2D

var transition_time = 0.4
var transitioning = false

func transition():
	if transitioning: return
	
	transitioning = true
	
	var animation_player = $AnimationPlayer
	animation_player.play("in")
	yield(animation_player, "animation_finished")
	animation_player.play("out")
	
	transitioning = false
