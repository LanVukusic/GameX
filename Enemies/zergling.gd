extends Node2D

@onready var nav : NavigationAgent2D = $NavigationAgent2D

var moving = false;

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	if(moving == true and position.distance_to(nav.get_next_path_position()) < 10):
		print("[Zergling.gd] Stopping")
		moving = false;
	pass

func _physics_process(delta):
	if(moving):
		var direction = (nav.get_next_path_position() - global_position).normalized()
		translate(direction * 200 * delta)

func setDestination(pos: Vector2) -> void:
	print("[Zergling.gd] Got position ", pos)
	nav.target_position = pos;
	moving = true;
