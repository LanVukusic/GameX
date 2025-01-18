extends Node2D
class_name WeaponManager

signal weapon_switched
signal switch_weapons_pressed

#@export var current_bullet: PackedScene
@export var avaliable_weapons: Array[WeaponItem]
var weapon_stack: Array[WeaponBase] = [] # To hold instantiated Weapon nodes
@export var current_weapon: WeaponBase = null

func _ready() -> void:
	# Initialize weapons from available resources
	for w in avaliable_weapons:
		var weapon = w.scene.instantiate() as WeaponBase
		add_child(weapon)
		weapon_stack.append(weapon)
	
	switch_weapons_pressed.connect(switch_weapon)
	switch_weapon()


func switch_weapon():
	if weapon_stack.size() == 0:
		print("No weapons available to switch.")
		return
	# Find the next weapon index in a circular fashion
	var current_index = weapon_stack.find(current_weapon)
	var next_index = (current_index + 1) % weapon_stack.size()

	# Only keep the current weapon visible
	for w in weapon_stack:
		if (w.get_parent() != null):
			remove_child(w)
#			print("brisem ", w, w.get_parent())
	# Switch visibility and set the new weapon
	current_weapon = weapon_stack[next_index]
	add_child(current_weapon)

	current_weapon.is_shoot_pressed = false
	weapon_switched.emit()
	current_weapon.weapon_stats.force_signal()
	
	print("Switched to weapon:", current_weapon.name)
	
