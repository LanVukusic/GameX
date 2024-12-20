extends RigidBody2D
class_name Projectile
# Called when the node enters the scene tree for the first time.
@export var speed = 1000
@export var lifetime: float

func _ready() -> void:
	self.apply_central_impulse(Vector2.from_angle(self.rotation) * speed)
	
	
	# self.add_constant_central_force(Vector2.from_angle(self.global_rotation) * speed)
	var life_timer = Timer.new()
	add_child(life_timer)
	life_timer.one_shot = true
	life_timer.start(lifetime)
	life_timer.timeout.connect(queue_free)
	pass # Replace with function body.
