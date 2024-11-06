extends Node2D

@onready var rays := $Rays.get_children()
var observedBoids := []
var velocity := Vector2.ZERO
var speed := 1
var screensize : Vector2
var borderTL
var borderBR
var movv := 48

@export var swarmArea : Area2D

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	# We want these little dudes to swarm around a zone right
	# Gonna need to get the border points of the zone to calculate bounds
	# TL - top left
	# BR - bottom right
	var zoneSize = swarmArea.get_node("CollisionShape2D").shape.get_size()
	borderTL = Vector2(swarmArea.position.x - (zoneSize.x / 2), swarmArea.position.y - (zoneSize.y / 2))
	borderBR = Vector2(swarmArea.position.x + (zoneSize.x / 2), swarmArea.position.y + (zoneSize.y / 2))
	#print(borderTL)
	#print(borderBR)
	velocity = Vector2(randi() % 20, randi() % 20)
	randomize()
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	boids()
	checkCollision()
	velocity = velocity.normalized() * speed
	#print(velocity)
	move()
	rotation = lerp_angle(rotation, velocity.angle_to_point(Vector2.ZERO), 0.4)
	pass

func boids() -> void:
	if observedBoids:
		print(observedBoids)
		var numOfBoids := observedBoids.size()
		var avgVel := Vector2.ZERO
		var avgPos := Vector2.ZERO
		var steerAway := Vector2.ZERO
		for boid in observedBoids:
			avgVel += boid.velocity
			avgPos += boid.position
			steerAway -= (boid.global_position - global_position) * (movv / (global_position - boid.global_position)).length()
		
		avgVel /= numOfBoids
		velocity += (avgVel - velocity)/2
		
		avgPos /= numOfBoids
		velocity += (avgPos - position)
		
		steerAway /= numOfBoids
		velocity += (steerAway)
		
func checkCollision() -> void:
	for ray in rays:
		var r : RayCast2D = ray
		if r.is_colliding():
			if r.get_collider().is_in_group("World"):
				var magi := 100/(r.get_collision_point() - global_position).length_squared()
				velocity -= (r.target_position.rotated(rotation) * magi)
			pass
	pass

func move() -> void:
	# This sucks lol, replace with a rigidbody thing if performance allows eventually
	global_position += velocity
	#print(global_position)
	if global_position.x < borderTL.x:
		global_position.x = borderBR.x
		#print("A")
	if global_position.x > borderBR.x:
		global_position.x = borderTL.x
		#print("B")
	if global_position.y < borderTL.y:
		global_position.y = borderBR.y
		#print("C")
	if global_position.y > borderBR.y:
		global_position.y = borderTL.y
		#print("D")
		
func _on_vision_area_entered(area: Area2D) -> void:
	if area != self and area.is_in_group("Boid"):
		observedBoids.append(area)


func _on_vision_area_exited(area: Area2D) -> void:
	if area:
		observedBoids.erase(area)
