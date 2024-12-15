extends Node2D
class_name WeaponManager


signal switch_weapons_pressed
#@export var current_bullet: PackedScene
@export var avaliable_weapons: Array[PackedScene]
var weapon_stack: Array[Weapon] = [] # To hold instantiated Weapon nodes
@export var current_weapon: Weapon = null

func _ready() -> void:
	# Initialize weapons from available resources
	for w in avaliable_weapons:
		var weapon = w.instantiate() as Weapon
		add_child(weapon)
		weapon_stack.append(weapon)
		switch_weapon()

	switch_weapons_pressed.connect(switch_weapon)


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
			print("brisem ", w, w.get_parent())


	# Switch visibility and set the new weapon
	current_weapon = weapon_stack[next_index]
	add_child(current_weapon)

	print("Switched to weapon:", current_weapon.name)

func _input(event: InputEvent) -> void:
	# Listen for input to switch weapons
	# if event.is_action_pressed("WeaponSwitch"):
	# 	switch_weapon()
	if event.is_action_pressed("CheckTree"):
		print_tree()
