extends Area2D
class_name HitboxComponent

@export var attack: AttackComponent
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass


func _on_area_entered(hurtbox: HurtboxComponent) -> void:
		print("overlap")
		hurtbox.relay_damage(attack)
