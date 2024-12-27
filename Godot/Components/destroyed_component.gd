extends Node
class_name DestroyedComponent

@export var actor: Node2D
@export var health: HealthComponent
@export var spawn_component: SpawnerComponent

func _ready() -> void:
	health.sig_died.connect(destroyed)

func destroyed():
	spawn_component.spawn(actor.global_position)
