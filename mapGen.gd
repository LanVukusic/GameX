@tool
extends Node2D

@export_category("Properties")
@export var mapRoot:Node2D
@export var building:PackedScene

@export_category("Map generation")
@export var mapScale:float = 500000

# clear all buildings
@export var generateMap: bool:
	set(value):
		_generate_map()

# clear all buildings
@export var clearMap: bool:
	set(value):
		_clear_map()

func _clear_map():
	for node in mapRoot.get_children():
		mapRoot.remove_child(node)

func _generate_map():
	# load new json for world data
	var imported_resource = preload("res://polygons.json")
	
	if mapRoot == null  or building == null:
		push_error("Assign a map root node first")
		return

	for node in mapRoot.get_children():
		mapRoot.remove_child(node)

	for build_inst in imported_resource.data:
		var ar: PackedVector2Array = []
		for point in build_inst.data:
			ar.append(Vector2(point.x* mapScale, point.y* mapScale))
			
		var newBuild  = building.instantiate().new(ar) as Node2D
		newBuild.position = Vector2(
			build_inst.centroid.x * mapScale,
			build_inst.centroid.y * mapScale,
		)
		newBuild.visible = true
		mapRoot.add_child(newBuild)
		newBuild.owner = self
		newBuild.name = str(build_inst.id)
