extends Node2D
class_name WeaponManager

signal weapon_switched
signal switch_weapons_pressed

@export var avaliable_weapons: Array[WeaponItem]
var weapon_stack: Array[WeaponBase] = [] # To hold instantiated Weapon nodes
@export var current_weapon: WeaponBase = null

func _ready() -> void:
	# Initialize weapons from available resources
	initialize_weapons()
	connect_signals()
	switch_weapon()

func initialize_weapons() -> void:
	"""Instantiate weapons from available resources."""
	for weapon_resource in avaliable_weapons:
		add_weapon(weapon_resource, false)  # Add weapon without switching

func connect_signals() -> void:
	"""Connect signals for the weapon manager."""
	switch_weapons_pressed.connect(switch_weapon)

func add_weapon(weapon_resource: WeaponItem, switch_to_new: bool = true) -> void:
	"""Add a weapon to the stack. Optionally switch to it."""
	for weapon in weapon_stack:
		if weapon.name == weapon_resource.name:  # Assuming unique weapon names
			print("Duplicate weapon detected:", weapon_resource.name)
			return

	var instance = weapon_resource.scene.instantiate() as WeaponBase
	weapon_stack.append(instance)

	if switch_to_new:
		switch_weapon_to(instance)

func switch_weapon() -> void:
	"""Switch to the next weapon in the stack."""
	if weapon_stack.size() == 0:
		print("No weapons available to switch.")
		return

	# Determine the next weapon index
	var current_index = weapon_stack.find(current_weapon)
	var next_index = (current_index + 1) % weapon_stack.size()

	switch_weapon_to(weapon_stack[next_index])

func switch_weapon_to(weapon: WeaponBase) -> void:
	"""Switch to a specific weapon."""
	if current_weapon:
		if current_weapon.get_parent() == self:
			remove_child(current_weapon)

	current_weapon = weapon
	add_child(current_weapon)
	
	current_weapon.is_shoot_pressed = false  # Reset shooting state
	weapon_switched.emit()
	current_weapon.weapon_stats.force_signal()

	print("Switched to weapon:", current_weapon.name)

func get_current_weapon() -> WeaponBase:
	"""Retrieve the currently active weapon."""
	if current_weapon == null:
		print("No current weapon set!")
		return null
	return current_weapon
