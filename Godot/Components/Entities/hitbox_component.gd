extends Area2D
class_name HitboxComponent

@export var attack: AttackComponent
@export var status_effect: PackedScene
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	area_entered.connect(_on_area_entered)
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass


func _on_area_entered(area: Area2D) -> void:
	if area is HurtboxComponent:
		area.relay_damage(attack)
		area.relay_status_effect(status_effect)
	pass # Replace with function body.
