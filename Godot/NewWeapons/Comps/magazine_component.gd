extends Node
class_name MagazineComponent

# Signals
signal sig_ammo_change(curr_amount: int)
signal sig_magazine_change(curr_amount: int)

# --- Configuration ---
@export var capacity: int = 30
@export var max_magazines: int = 5
@export var time_needed_to_reload: float = 2.0
@export var reload_timer: Timer

# --- State ---
enum magazine_state { READY, RELOADING }
var current_magazine_state: magazine_state = magazine_state.READY

# Reactive Ammo Variable
var current_ammo: int:
	set(value):
		# Clamp between 0 and Capacity
		value = clamp(value, 0, capacity)
		current_ammo = value
		sig_ammo_change.emit(current_ammo)

# Reactive Magazine Variable
var current_mags: int:
	set(value):
		# Clamp between 0 and 100 (Arbitrary max)
		value = clamp(value, 0, 100)
		current_mags = value
		sig_magazine_change.emit(current_mags)

func _ready() -> void:
	if reload_timer:
		reload_timer.timeout.connect(_on_reload_timer_timeout)
		reload_timer.wait_time = time_needed_to_reload # Sync timer with variable
	else:
		print("Warning: Reload timer is not assigned in " + name)

	call_deferred("_initialize_ammo")

func _initialize_ammo() -> void:
	current_ammo = capacity
	current_mags = max_magazines
	# Force update UI
	sig_ammo_change.emit(current_ammo)
	sig_magazine_change.emit(current_mags)

# --- PUBLIC API (Called by BaseWeapon) ---

# Simple check: Do we have ammo AND are we finished reloading?
func has_ammo() -> bool:
	if current_magazine_state == magazine_state.RELOADING:
		return false
	return current_ammo > 0

# Deduct 1 bullet. 
# We don't return a projectile scene anymore. The Barrel handles that.
func consume() -> void:
	if current_ammo > 0:
		current_ammo -= 1

# Start Reloading
func start_reload():
	if current_magazine_state == magazine_state.RELOADING:
		return
	
	if current_mags <= 0:
		print("Click! (Out of Mags)")
		return
		
	# Check if we actually NEED to reload
	if current_ammo == capacity:
		return

	print("Reloading...")
	current_magazine_state = magazine_state.RELOADING
	if reload_timer:
		reload_timer.start(time_needed_to_reload)

# --- Internal Logic ---

func _on_reload_timer_timeout():
	current_mags -= 1
	current_ammo = capacity
	current_magazine_state = magazine_state.READY
	print("Reload Complete!")
