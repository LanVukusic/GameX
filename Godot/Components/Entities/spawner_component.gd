extends Node2D
class_name SpawnerComponent

@export var scene: PackedScene
# Called when the node enters the scene tree for the first time.


func spawn(global_spawn_position: Vector2 = global_position, parent: Node = get_tree().current_scene) -> Node:
	assert(scene is PackedScene, "Error: The scene export variable was not set!")
	var instance = scene.instantiate()
	parent.add_child(instance)
	instance.global_position = global_spawn_position	
	return instance
