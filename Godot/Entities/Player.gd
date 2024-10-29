class_name Player
extends CharacterBody2D

@export_category("Movement config")
@export var moveSpeed: float
@export var multiplayerId: int = 0
@export var color: Color

@export var maxHealth: int = 100
@export var curHealth: int = maxHealth

@export var DEBUG_EnemyTest: Node2D

signal moveVec(vec: Vector2)
signal lookVec(vec: Vector2)
signal lamp()


var _input_direction = Vector2(0, 0)



func set_input_direction(vec: Vector2):
	_input_direction = vec

func set_look_direction(vec: Vector2):
	self.rotation = vec.angle() + PI / 2

func get_input():
	var input_dir = Input.get_vector("ui_left", "ui_right", "ui_up", "ui_down")
	set_input_direction(input_dir)

func toggle_lamp():
	$PointLight2D.enabled = !$PointLight2D.enabled

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	moveVec.connect(set_input_direction)
	lookVec.connect(set_look_direction)
	lamp.connect(toggle_lamp)

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _physics_process(_delta: float) -> void:
	get_input()
	self.velocity = _input_direction * moveSpeed
	#self.position += velocity * _delta
	move_and_slide()

func new(id: int):
	self.multiplayerId = id
	return self

# func _physics_process(delta):
# 	get_input()
# 	move_and_slide()

func _on_hurt_box_area_entered(area: Area2D) -> void:
	if area.owner.is_in_group("Enemy"):
		print("Collided")
		var areaDamage = 5
		curHealth -= areaDamage
	pass # Replace with function body.


# Debug for testing pathfinding, goes to player when 'x' is pressed
func _input(event):
	if event is InputEventKey and event.pressed and event.keycode == 88:
		print("[Player.gd] x")
		DEBUG_EnemyTest.setDestination(position)
