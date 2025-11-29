extends CharacterBody2D

@onready var health_component: HealthComponent = $HealthComponent
@onready var hurtbox: HurtboxComponent = $HurtboxComponent
@onready var sprite: Sprite2D = $Sprite2D
@onready var label_marker: Marker2D = $DamageLabelMarker

@export var damage_number_scene: PackedScene 

# Physics for Knockback
var knockback_velocity: Vector2 = Vector2.ZERO
@export var friction: float = 800.0

func _ready() -> void:
	# Connect our components
	health_component.sig_health_changed.connect(_on_health_changed)
	health_component.sig_died.connect(_on_death)
	hurtbox.sig_hit_received.connect(_on_hit_received)

func _physics_process(delta: float) -> void:
	# 1. Apply Friction (Slow down over time)
	if knockback_velocity.length() > 0:
		knockback_velocity = knockback_velocity.move_toward(Vector2.ZERO, friction * delta)
	
	# 2. Move
	velocity = knockback_velocity
	move_and_slide()

func _on_hit_received(hit: HitInfo):
	# Apply the physics from the HitInfo packet
	knockback_velocity = hit.direction * hit.knockback_force
	
	# Spawn visual number
	spawn_damage_number(hit.damage)

func _on_health_changed(new_health: int) -> void:
	# Flash Red Effect
	var tween = create_tween()
	tween.tween_property(sprite, "modulate", Color.RED, 0.05)
	tween.tween_property(sprite, "modulate", Color.WHITE, 0.05)

func _on_death() -> void:
	# Reset dummy instead of destroying it
	health_component._init_health(health_component.max_health)

func spawn_damage_number(amount: int):
	if damage_number_scene:
		var dmg = damage_number_scene.instantiate()
		get_tree().root.add_child(dmg)
		dmg.global_position = label_marker.global_position
		dmg.setup(amount)
