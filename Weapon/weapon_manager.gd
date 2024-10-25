extends Node2D

signal Weapon_Changed
signal Weapon_stack
signal Update_weapon_stack

var current_weapon = null
var weapon_stack = []
var weapon_indicator = 0

var total_ammo_capacity: int

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass

func _input(event: InputEvent) -> void:
	if event.is_action_pressed("Shoot"):
		fire()
	if event.is_action_pressed("Reload"):
		reload()


func fire():
	pass

func reload():
	pass
