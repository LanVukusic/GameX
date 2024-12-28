extends CharacterBody2D

@export var health_component: HealthComponent

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
    health_component.sig_died.connect(queue_free)
    pass # Replace with function body.

func _physics_process(delta):
    pass
