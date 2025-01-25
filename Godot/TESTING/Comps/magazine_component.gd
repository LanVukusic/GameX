extends Node
class_name MagazineComponent

signal sig_ammo_change(curr_amount: int)
signal sig_magazine_change(curr_amount: int)

@export var projectile: PackedScene

var current_ammo: int:
	set(value):
		clampi(value, 0, capacity)
		current_ammo = value
		sig_ammo_change.emit(current_ammo)

var current_mags: int:
	set(value):
		clampi(value, 0, 100) #tbd
		current_mags = value
		sig_magazine_change.emit(current_mags)

@export var capacity: int
@export var magazines: int
@export var reload_timer: Timer


enum magazine_state { READY, RELOADING }
var curret_magazine_state: magazine_state


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass

func get_projectile() -> PackedScene:
	if curret_magazine_state == magazine_state.READY:
		current_ammo -= 1
		return projectile
	print("Out of ammo")
	return null

func reload():
	if curret_magazine_state == magazine_state.RELOADING:
		print("Already reloading.")
		return
	
	if magazines <= 0:
		print("Out of magazines")
		return
	
	reload_timer.start()
	reload_timer.timeout.connect(_on_reload_timer_timeout)
	curret_magazine_state = magazine_state.RELOADING

func _on_reload_timer_timeout():
	magazines -= 1
	current_ammo = capacity
	curret_magazine_state = magazine_state.READY
	
