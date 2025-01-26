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
	connect_health_and_player_signals()
	
	# Connect weapon switching signal from the WeaponManager
	if connected_player and connected_player.weapon_manager:
		connected_player.weapon_manager.weapon_switched.connect(_on_weapon_switched)
	
	# Initialize weapon-related signals for the current weapon
	_initialize_weapon_signals()

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

func _on_player_death():
	print("Player died")
	self.queue_free()

func connect_health_and_player_signals():
	# Health-related signals
	if connected_player and connected_player.healthcomponent:
		connected_player.healthcomponent.sig_health_changed.connect(set_curr_health)
		connected_player.healthcomponent.sig_died.connect(_on_player_death)

	# Player-related signals
	if connected_player:
		connected_player.joined.connect(set_player_color_name)

func _on_weapon_switched():
	# Reinitialize weapon-related signals when the weapon switches
	_initialize_weapon_signals()

func _initialize_weapon_signals():
	if not connected_player or not connected_player.weapon_manager:
		return

	var current_weapon = connected_player.weapon_manager.get_current_weapon()

	# Skip if there's no current weapon
	if not current_weapon:
		return

	# Disconnect existing signals to avoid duplicates
	if current_weapon.magazine.sig_ammo_change.is_connected(set_curr_ammo_count):
		current_weapon.magazine.sig_ammo_change.disconnect(set_curr_ammo_count)

	if current_weapon.magazine.sig_magazine_change.is_connected(set_curr_mag_count):
		current_weapon.magazine.sig_magazine_change.disconnect(set_curr_mag_count)

	# Connect new signals for the current weapon
	current_weapon.magazine.sig_ammo_change.connect(set_curr_ammo_count)
	current_weapon.magazine.sig_magazine_change.connect(set_curr_mag_count)

	# Force a signal update for the current weapon stats
	#current_weapon.magazine._emit_ui_singnals()
