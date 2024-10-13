@tool
extends Polygon2D

@export_category("Building properties")
@export var wallThickness: float
@export var wallLengthExtension: float
# @export var recalculatePolygon: bool:
# 	set(value):
# 		init_building_shape(self.polygon)

@export_category("Dev Utils")
# clear all buildings
# @export var generateMap: bool:
# 	set(value):
# 		print("nekaj")

func _clear_all():
	for node in self.get_children():
		self.remove_child(node)

# create a single wall
func _create_wall(center: Vector2, angle: float, length: float):
	# init collision shape for the wall
	var wall = CollisionShape2D.new()
	wall.position = center
	wall.rotation = angle
	
	# init rectangular wall
	var shape = RectangleShape2D.new()
	shape.size.x = length + wallLengthExtension
	shape.size.y = wallThickness
	
	# set the wall shape
	wall.shape = shape
	
	$Walls.add_child(wall)
	wall.visible = true
	wall.owner = self
	
func _crate_walls():
	for i in range(len(self.polygon) - 1):
		var p1 = self.polygon[i] # first point
		var p2 = self.polygon[(i + 1)] # second point that loops around
		var wallCenter = (p1 + p2) / 2 # calculate wall center as the midpoint of two vertex points
		var directionVect = (p1 - p2)
		
		var angle = directionVect.angle()
		var wallLength = directionVect.length()

		_create_wall(wallCenter, angle, wallLength)
	return

func _clear_walls():
	for node in $Walls.get_children():
		$Walls.remove_child(node)
	
func init_building_shape(points: PackedVector2Array) -> void:
	self.polygon = points
	$Area2D/AreaCollisionShape.polygon = points
	_crate_walls()

func update_building_shape(points: PackedVector2Array) -> void:
	# self.polygon = points # DO NOT UNCOMMENT - results in infinite recursion
	$Area2D/AreaCollisionShape.polygon = points
	_clear_walls()
	_crate_walls()

func new(points: PackedVector2Array) -> Polygon2D:
	init_building_shape(points)
	return self


func _set(property: StringName, value: Variant) -> bool:
	if property == "polygon":
		update_building_shape(value)
	return false

	
# func _process(delta: float) -> void:
# 	#print("ojla")
# 	pass
