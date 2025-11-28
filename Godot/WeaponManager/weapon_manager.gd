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
	# 1. Instantiate the visual model (The Scene from the Resource)
	var instance = weapon_resource.scene.instantiate() as WeaponBase
	
	# 2. INJECT THE DATA (The Critical New Step)
	# The gun is "dumb" until we give it the stats
	instance.setup(weapon_resource) 
	
	# 3. Add to stack as normal
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
	
	current_weapon.is_trigger_held = false  # Reset shooting state
	weapon_switched.emit()

	print("Switched to weapon:", current_weapon.name)

func get_current_weapon() -> WeaponBase:
	"""Retrieve the currently active weapon."""
	if current_weapon == null:
		print("No current weapon set!")
		return null
	return current_weapon
