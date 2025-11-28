extends Resource  # <--- MUST be Resource, not Node!
class_name AttackComponent # <--- This line is MANDATORY

@export var damage: int = 10
@export var knockback_force: float = 300.0
@export var stun_time: float = 0.2
