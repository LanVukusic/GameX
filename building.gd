@tool
extends Area2D

@export_category("Building properties")
@export var wallThickness:float = 0.2
## clear all buildings
#@export var debugButton: bool:
	#set(value):
		#print("oj")


#@export var vertexPoints:PackedVector2Array = []:
	#set(new_setting):
		#vertexPoints = new_setting
		## Emit a signal when the property is changed.
		#self._clear_all()

func _clear_all():
	for node in self.get_children():
		self.remove_child(node)
		
func _crate_walls():
	return
	
func update_building_shape(points: PackedVector2Array) -> void:
	$MainShapePolygon.polygon = points
	$AreaCollisionShape.polygon = points
	print("build shape updated")

func new(points: PackedVector2Array) -> Area2D:
	update_building_shape(points)
	return self

func _ready() -> void:
	print("ready")
	
func _process(delta: float) -> void:
	#print("ojla")
	pass
