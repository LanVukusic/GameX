extends Resource
class_name StatusEffectBase

signal status_applied

@export var name: String
@export_category("Visuals")
@export var scene: PackedScene
@export var texture: Texture2D

@export_category("Status Data")
@export var duration: float
@export var damage: int
@export var can_expire: bool

func init_status():
	pass

func apply_status_effect(target: Player):
	if can_expire:
		var effect_scene = scene.instantiate()
		target.status_effect_handler.add_child(effect_scene)
		target.stats.take_damage(damage)

func create_one_shot_timer(time: float):
	var timer = Timer.new()
	timer.one_shot = true
	timer.start(duration)
