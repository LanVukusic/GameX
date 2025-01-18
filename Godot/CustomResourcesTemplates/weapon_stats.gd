extends Resource
class_name WeaponStats

signal ammo_change(ammo_count: int)
signal magazine_change(mag_count: int)

@export_category("Description")
@export var name: String


@export_category("Sound")
var resource: Resource


@export_category("All ammunition")
@export var max_magazines: int

var current_mags: int:
	set(value):
		clampi(value, 0, max_magazines)
		current_mags = value
		magazine_change.emit(current_mags)

# Maximum ammo that can fit into the weapon's magazine (clip size)
@export var magazine_capacity: int

var current_mag_ammo: int:
	set(value):
		clampi(value, 0, magazine_capacity)
		current_mag_ammo = value
		ammo_change.emit(current_mag_ammo)


@export_category("Fire logic")
# The reload time for the weapon (in seconds)
@export var reload_time: float
# Fire rate (how many bullets can be fired per second)
@export var fire_rate: float
# Boolean to determine if the weapon is automatic or semi-automatic
@export var is_automatic: bool
# The weapon's damage per shot
@export var damage_per_shot: float
# The weapon's range (could be in arbitrary units, depending on the game design)
@export var weapon_range: float
#The spread of bullets
@export var bullet_spread: float


func init_weapon_values():
	current_mag_ammo = magazine_capacity
	current_mags = max_magazines
	pass

func change_magazine_count(amount: int):
	current_mags += amount

func change_ammo_count(amount: int):
	current_mag_ammo += amount

func replenish_ammo():
	current_mag_ammo = magazine_capacity


func force_signal() -> void:
	ammo_change.emit(current_mag_ammo)
	magazine_change.emit(current_mags)
