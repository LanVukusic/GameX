extends CharacterBody2D
@onready var nav : NavigationAgent2D = $NavigationAgent2D

@export var health_component: HealthComponent

var moving = false;
var isAlert = false;
var reset_state = false
var moveVector: Vector2
var lockedOn : Node2D

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	health_component.sig_died.connect(on_death)
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	if(moving == true and position.distance_to(lockedOn.position) < 100):
		if($NavigationAgent2D.radius != 5):
			print(name, " Loose avoidance")
		$NavigationAgent2D.radius = 5
	elif moving == true and position.distance_to(lockedOn.position) < 600:
		if($NavigationAgent2D.radius != 12):
			print(name, " Strictish avoidance")
		$NavigationAgent2D.radius = 12
	elif moving == true and position.distance_to(lockedOn.position) >= 800:
		if($NavigationAgent2D.radius != 15):
			print(name, " Strict avoidance")
		$NavigationAgent2D.radius = 15
	
	if(moving == true and position.distance_to(nav.get_next_path_position()) < 10) or (moving == true and position.distance_to(lockedOn.position) < 60):
		print(name, " Stopping")
		moving = false
		isAlert = false
		lockedOn = null
	pass

func _physics_process(delta):
	if(moving):
		var direction : Vector2
		if(lockedOn != null):
			setDestination(lockedOn.position)
		direction = (nav.get_next_path_position() - global_position).normalized()
		#move_body(direction * 200 * delta)
		velocity = (direction * 200)
		if $NavigationAgent2D.avoidance_enabled:
			$NavigationAgent2D.set_velocity(velocity)
		else:
			_on_velocity_computed(velocity)

func setDestination(pos: Vector2) -> void:
	#print("[Zergling.gd] Got position ", pos)
	nav.target_position = pos;
	moving = true;
	
func alertTo(tar: Node2D) -> void:
	if isAlert:
		print(name, " Still alert sorry")
		return
	isAlert = true
	lockOn(tar)
	alertOthers(tar)
	setDestination(tar.position)
	
func alertOthers(tar: Node2D) -> void:
	var nearbyBodies = $AlertZone.get_overlapping_bodies()
	print(nearbyBodies)
	for body in nearbyBodies:
		print(name, " Found: ", body)
		if body != self and body.is_in_group("Enemy"):
			print(name, " Found: ", body)
			if !body.isAlert:
				body.alertTo(tar)
			
func lockOn(tar: Node2D) -> void:
	lockedOn = tar


func _on_navigation_agent_2d_velocity_computed(safe_velocity: Vector2) -> void:
	if(moving):
		velocity = safe_velocity
		move_and_slide()
	pass # Replace with function body.

func on_death():
	self.queue_free()

func _on_velocity_computed(safe_velocity: Vector2):
	print("cumming")
	velocity = safe_velocity
	move_and_slide()
