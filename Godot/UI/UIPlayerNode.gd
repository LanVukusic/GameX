extends Control
class_name UIPlayerNode

@export var connected_player: Player

@onready var ammo: Label = %AmmoValue
@onready var mag: Label = %MagValue
@onready var player_name: Label = %PlayerName
@onready var color_rect: ColorRect = %Divider
@onready var health: Label = %HPValue

# Track the last weapon so we can disconnect it properly
var last_connected_weapon: WeaponBase = null

func _ready() -> void:
	connect_health_and_player_signals()
	
	if connected_player and connected_player.weapon_manager:
		connected_player.weapon_manager.weapon_switched.connect(_on_weapon_switched)
		# Initialize immediately if a weapon is already equipped
		_on_weapon_switched()

# --- UI SETTERS ---

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

# --- SIGNAL CONNECTIONS ---

func connect_health_and_player_signals():
	if connected_player and connected_player.healthcomponent:
		connected_player.healthcomponent.sig_health_changed.connect(set_curr_health)
		connected_player.healthcomponent.sig_died.connect(_on_player_death)

	if connected_player:
		connected_player.joined.connect(set_player_color_name)

func _on_weapon_switched():
	# 1. DISCONNECT OLD WEAPON
	if last_connected_weapon and is_instance_valid(last_connected_weapon):
		if last_connected_weapon.magazine:
			if last_connected_weapon.magazine.sig_ammo_change.is_connected(set_curr_ammo_count):
				last_connected_weapon.magazine.sig_ammo_change.disconnect(set_curr_ammo_count)
			if last_connected_weapon.magazine.sig_magazine_change.is_connected(set_curr_mag_count):
				last_connected_weapon.magazine.sig_magazine_change.disconnect(set_curr_mag_count)

	# 2. GET NEW WEAPON
	if not connected_player or not connected_player.weapon_manager:
		return

	var current_weapon = connected_player.weapon_manager.get_current_weapon()
	last_connected_weapon = current_weapon # Save for next time

	# 3. SAFETY CHECKS
	if not current_weapon:
		# No weapon equipped (Hands empty)
		ammo.text = ""
		mag.text = ""
		return

	if current_weapon.magazine == null:
		# Weapon exists but has no magazine (Sword/Melee)
		ammo.text = "∞" 
		mag.text = ""
		return 

	# 4. CONNECT NEW WEAPON
	current_weapon.magazine.sig_ammo_change.connect(set_curr_ammo_count)
	current_weapon.magazine.sig_magazine_change.connect(set_curr_mag_count)

	# 5. INITIAL UPDATE
	set_curr_ammo_count(current_weapon.magazine.current_ammo)
	set_curr_mag_count(current_weapon.magazine.current_mags)
