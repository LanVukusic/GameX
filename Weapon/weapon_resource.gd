extends Resource
class_name WeaponResource

# Maximum ammunition the player can carry across all magazines
@export var total_ammo_capacity: int

# Current ammunition the player has available to reload into the weapon
@export var current_reserve_ammo: int

# Maximum ammo that can fit into the weapon's magazine (clip size)
@export var magazine_capacity: int

# Current amount of ammunition in the weapon's loaded magazine
@export var ammo_in_magazine: int

# Number of additional full magazines the player holds
@export var spare_magazines: int

# The texture used for the weapon
@export var texture: Texture2D

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
