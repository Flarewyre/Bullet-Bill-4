extends Node2D

const BOUNDS = Vector2(26, 15)
var obstacles : Array

func _init():
	var test_obstacle = Obstacle.new()
	test_obstacle.type = 1
	test_obstacle.position = Vector2(3, 12)
	var test_obstacle_2 = Obstacle.new()
	test_obstacle_2.type = 1
	test_obstacle_2.position = Vector2(3, 6)
	test_obstacle_2.flipped = true
	
	var btest_obstacle = Obstacle.new()
	btest_obstacle.type = 3
	btest_obstacle.position = Vector2(9, 8)
	var btest_obstacle_2 = Obstacle.new()
	btest_obstacle_2.type = 3
	btest_obstacle_2.position = Vector2(9, 2)
	btest_obstacle_2.flipped = true
	
	var atest_obstacle = Obstacle.new()
	atest_obstacle.type = 1
	atest_obstacle.position = Vector2(18, 10)
	var atest_obstacle_2 = Obstacle.new()
	atest_obstacle_2.type = 1
	atest_obstacle_2.position = Vector2(18, 4)
	atest_obstacle_2.flipped = true
	
	obstacles = [test_obstacle, test_obstacle_2, btest_obstacle, btest_obstacle_2, atest_obstacle, atest_obstacle_2]

func load_room():
	create_obstacles()
	
func create_obstacles():
	var index = 0
	for obstacle in obstacles:
		obstacle.height = obstacle.determine_height(BOUNDS.y)
		
		var obstacle_node = obstacle.return_node()
		obstacle_node.position = obstacle.position * 16
		obstacle_node.set_height(obstacle.height)
		if obstacle.flipped:
			obstacle_node.flip()
		obstacle_node.name = "Obstacle_" + str(index)
		add_child(obstacle_node)
		index += 1
