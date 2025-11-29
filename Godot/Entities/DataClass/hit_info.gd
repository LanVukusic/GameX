# HitInfo.gd
class_name HitInfo
extends RefCounted 

# These are the variables you will see in Autocomplete!
var damage: int
var knockback_force: float
var direction: Vector2
var stun_time: float
var source: Node

# The Constructor: Makes it easy to build in one line
func _init(_dmg: int, _force: float, _dir: Vector2, _stun: float, _src: Node):
	damage = _dmg
	knockback_force = _force
	direction = _dir
	stun_time = _stun
	source = _src
