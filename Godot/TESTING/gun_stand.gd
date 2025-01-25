extends Node2D
#class WeaponBase

@export var barrel:BarrelComponent
@export var magazine: MagazineComponent

var is_shoot_pressed: bool = false
var can_shoot: bool = true
@export var fire_rate: float #in seconds
@export var is_automatic: bool
@export var fire_cooldown: Timer

func _physics_process(_delta: float) -> void:
	if  is_shoot_pressed and is_automatic:
		fire()

func _on_fire_timer_timeout():
	can_shoot = true

func on_shoot_active() -> void:
	fire()
	is_shoot_pressed = true

func on_shoot_relase() -> void:
	is_shoot_pressed = false

func fire() -> void:
	if can_shoot:
		barrel.spawn_bullet(magazine.get_projectile())
	
	fire()
	can_shoot = false
	fire_cooldown.start(fire_rate)
