
# weapon_item.gd
extends Item  # <--- INHERITS name, scene, sprite from your existing system!
class_name WeaponItem

@export_category("Gun Stats")
@export var attack_data: AttackComponent # The damage info
@export var fire_rate: float = 0.2
@export var projectiles_per_shot: int = 1
@export var spread_angle: float = 5.0
@export var max_ammo: int = 30
@export var projectile_speed: float = 1200.0

@export var projectile_scene: PackedScene
