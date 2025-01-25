class_name Player
extends CharacterBody2D

@export_category("DEBUG AND DEV")
@export var multiplayerId: int

@export_category("Movement config")
@export var color: Color


@export_category("Components")
@export var stats: GeneralStats
@export var status_effect_hander: StatusEffectHandler
@export var weapon_manager: WeaponManager
@export var healthcomponent: HealthComponent
@export var move_input_component: MoveInputComponent
@export var look_input_component: LookInputComponent
@export var inventory: InventoryComponent


signal joined(color: Color, name: String)

func toggle_lamp():
	$PointLight2D.enabled = !$PointLight2D.enabled

func conn(col: Color, _name: String):
	print("joined")
	color = col
	$ModulatableSprite.modulate = col
	self.name = _name


func _init() -> void:
	joined.connect(conn)
	
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	healthcomponent.sig_died.connect(die)
	pass

func new(id: int):
	self.multiplayerId = id
	return self

func die():
	print("DED!!!")
	queue_free()
