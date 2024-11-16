extends RigidBody2D
class_name BaseProjectile

@export_category("info")
@export var projectile_name: String
@export var active_stack: Array[PackedScene]

func with_data(stack: Array[PackedScene]):
	self.active_stack = stack
	self.bullet_setup()
	return self
	

# Called when bullet data is initialized using with_data
func bullet_setup():
	pass

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	if (active_stack == null):
		push_error("No active stack recieved. use `projectile.instantiate().with_data(activeStack)`")
	self.body_shape_entered.connect(on_hit)
	projectile_spawned()

func projectile_spawned():
	pass

func on_hit(_body_rid: RID, _body: Node, _body_shape_index: int, _local_shape_index: int):
	queue_free()
