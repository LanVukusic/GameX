extends Node

@export_category("Tester properties")
@export var fire_rate_sec: float
@export var projectile_speed: float
@export var projectile_transform: RayCast2D
@export var projectile_stack: Array[PackedScene]

var active_stack: Array[PackedScene]


@export_category("Projectile settings")
@export var projectile: PackedScene

var timer: Timer

var spawn_pos: Vector2
var dir: Vector2

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	timer = Timer.new()
	add_child(timer)
	timer.start(fire_rate_sec)
	timer.timeout.connect(shoot)
	timer.start()


func shoot():
	if (len(active_stack) == 0):
		active_stack = projectile_stack.duplicate()

	var p = active_stack.pop_front().instantiate().with_data(active_stack) as BaseProjectile
	p.position = spawn_pos
	p.apply_central_impulse(dir * projectile_speed)
	add_child(p)

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta: float) -> void:
	spawn_pos = projectile_transform.position
	dir = (projectile_transform.target_position - spawn_pos).normalized()
