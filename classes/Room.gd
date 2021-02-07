extends Node2D

const BOUNDS = Vector2(26, 15)
var obstacles := []
var objects := []
var room_index := 0

func _init():
	pass
	#obstacle_data = [
	#	[Vector2(3, 12), 1, false],
	#	[Vector2(3, 6), 1, true],
		
	#	[Vector2(9, 8), 3, false],
	#	[Vector2(9, 2), 3, true],
		
	#	[Vector2(18, 10), 1, false],
	#	[Vector2(18, 4), 1, true]
	#]

func obstacle_data_to_nodes():
	obstacles.clear()

	for data in CurrentLevelData.level.rooms[room_index].obstacles:
		var new_obstacle = Obstacle.new()
		new_obstacle.type = data[1]
		new_obstacle.position = data[0]
		new_obstacle.flipped = data[2]
		
		obstacles.append(new_obstacle)

func create_objects():
	objects.clear()

	var object_id_mapper = load("res://objects/ids.tres")
	var index = 0
	for data in CurrentLevelData.level.rooms[room_index].objects:
		var new_object_name = object_id_mapper.ids[data[1]]
		var new_object = load("res://objects/" + new_object_name + "/" + new_object_name + ".tscn").instance()
		new_object.position = data[0] * 16
		new_object.name = "Object_" + str(index)
		new_object.index = index
		
		objects.append(new_object)
		$Objects.add_child(new_object)
		index += 1

func load_room():
	for child in $Obstacles.get_children():
		child.queue_free()
	for child in $Objects.get_children():
		child.queue_free()

	obstacle_data_to_nodes()
	create_obstacles()
	create_objects()
	
func create_obstacles():
	var index = 0
	for obstacle in obstacles:
		obstacle.height = obstacle.determine_height(BOUNDS.y)
		
		var obstacle_node = obstacle.return_node()
		obstacle_node.position = obstacle.position * 16
		obstacle_node.set_height(obstacle.height)
		if obstacle.flipped:
			obstacle_node.flip()

		obstacle_node.set_theme(CurrentLevelData.level.theme)
		obstacle_node.index = index
		obstacle_node.name = "Obstacle_" + str(index)
		
		$Obstacles.add_child(obstacle_node)
		index += 1
