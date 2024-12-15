extends Control
class_name UIPlayerNode

@export var connected_player: Player

@onready var ammo: Label = %AmmoValue
@onready var mag: Label = %MagValue


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	connect_singals()
	connected_player.weapon_manager.weapon_switched.connect(connect_singals)
	pass # Replace withv function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
# func _process(delta: float) -> void:
# 	pass

func set_curr_ammo_count(ammo_count: int):
	ammo.text = str(ammo_count)

func set_curr_mag_count(mag_count: int):
	mag.text = str(mag_count)

func connect_singals():
	connected_player.weapon_manager.current_weapon.current_ammo.connect(set_curr_ammo_count)
	connected_player.weapon_manager.current_weapon.current_magazines.connect(set_curr_mag_count)
