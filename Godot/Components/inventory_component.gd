extends Node
class_name InventoryComponent

@export var items_held: Array[Item]
@export var weapon_manager: WeaponManager

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass


func add_item(item: Item):
	if item is WeaponItem:
		weapon_manager.add_weapon(item)
	
	items_held.append(item)


func drop_item(item: Item):
	pass
