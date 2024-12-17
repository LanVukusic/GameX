extends Control
class_name UIPlayerNode

@export var connected_player: Player

@onready var ammo: Label = %AmmoValue
@onready var mag: Label = %MagValue
@onready var player_name: Label = %PlayerName
@onready var color_rect: ColorRect = %Divider
@onready var health: Label = %HPValue

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	connected_player.weapon_manager.weapon_switched.connect(connect_singals)
	connect_singals()

func set_curr_ammo_count(ammo_count: int):
	ammo.text = str(ammo_count)

func set_curr_mag_count(mag_count: int):
	mag.text = str(mag_count)

func set_curr_health(hp_count: int):
	health.text = str(hp_count)

func set_player_color_name(color: Color, name_in: String):
	player_name.text = str(name_in)
	var new_style = StyleBoxFlat.new()
	new_style.border_color = color
	new_style.border_width_bottom = 4
	new_style.border_width_top = 4
	new_style.border_width_left = 4
	new_style.border_width_right = 4
	self.add_theme_stylebox_override("panel", new_style)
	color_rect.color = color


func connect_singals():
	if (!connected_player.weapon_manager.current_weapon.current_ammo.is_connected(set_curr_ammo_count)):
		connected_player.weapon_manager.current_weapon.current_ammo.connect(set_curr_ammo_count)

	if (!connected_player.weapon_manager.current_weapon.current_magazines.is_connected(set_curr_mag_count)):
		connected_player.weapon_manager.current_weapon.current_magazines.connect(set_curr_mag_count)

	if (!connected_player.joined.is_connected(set_player_color_name)):
		connected_player.joined.connect(set_player_color_name)

	if (!connected_player.stats.health_changed.is_connected(set_curr_health)):
		connected_player.stats.health_changed.connect(set_curr_health)
