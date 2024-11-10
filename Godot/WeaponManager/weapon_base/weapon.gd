@tool

extends Node2D
class_name Weapon

@export var WEAPON : WeaponResource:
	set(value):
		WEAPON = value
		if Engine.is_editor_hint():
			load_weapon()

@onready var sprite: Sprite2D = %WeaponSprite
@onready var raycast: RayCast2D = %BulletTransform

func _ready() -> void:
	load_weapon()


func load_weapon() -> void:
	sprite.texture = WEAPON.sprite_texture
	sprite.position = WEAPON.sprite_pos
	sprite.scale = WEAPON.sprite_scale
	raycast.target_position = WEAPON.raycast_target_pos
	raycast.position = WEAPON.raycast_pos
