extends RigidBody2D
class_name Projectile
# Called when the node enters the scene tree for the first time.
@export var lifetime: float
@export var move_component: RigidBodyMoveComponent

func _ready() -> void:
	var life_timer = Timer.new()
	add_child(life_timer)
	life_timer.one_shot = true
	life_timer.start(lifetime)
	life_timer.timeout.connect(queue_free)
	pass # Replace with function body.
