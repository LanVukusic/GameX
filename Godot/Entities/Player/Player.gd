class_name Player
extends CharacterBody2D

@export_category("DEBUG AND DEV")
@export var multiplayerId: int

@export_category("Movement config")
@export var color: Color


@export_category("Components")
@export var stats: GeneralStats
@export var weapon_manager: WeaponManager
@export var healthcomponent: HealthComponent
@export var move_input_component: MoveInputComponent
@export var look_input_component: LookInputComponent


signal joined(color: Color, name: String)
#signal moveVec(vec: Vector2)
#signal lookVec(vec: Vector2)
#signal lamp()

var _input_direction = Vector2(0, 0)

func set_input_direction(vec: Vector2):
	_input_direction = vec

#func set_look_direction(vec: Vector2):
#	var target = vec.angle() + PI / 2
#	var lookSpeed = 0.1
#	self.rotation = lerp_angle(self.rotation, target, lookSpeed)

func toggle_lamp():
	$PointLight2D.enabled = !$PointLight2D.enabled

func conn(col: Color, _name: String):
	print("joined")
	color = col
	$ModulatableSprite.modulate = col
	self.name = _name


func _init() -> void:
#	moveVec.connect(set_input_direction)
#	lookVec.connect(set_look_direction)
#	lamp.connect(toggle_lamp)
	joined.connect(conn)
	
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	healthcomponent.sig_died.connect(queue_free)
	pass

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _physics_process(_delta: float) -> void:
	self.velocity = _input_direction * stats.move_speed
	move_and_slide()

func new(id: int):
	self.multiplayerId = id
	return self
