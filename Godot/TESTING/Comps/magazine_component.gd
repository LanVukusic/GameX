extends Node
class_name MagazineComponent

# Signals to notify other systems about ammo and magazine changes
signal sig_ammo_change(curr_amount: int)
signal sig_magazine_change(curr_amount: int)

# The projectile to spawn when firing
@export var projectile: PackedScene

# Current ammo in the magazine, clamped between 0 and the magazine capacity
var current_ammo: int:
	set(value):
		value = clamp(value, 0, capacity) # Ensure ammo does not exceed capacity or go below 0
		current_ammo = value
		sig_ammo_change.emit(current_ammo) # Emit signal to update ammo-dependent systems

# Current number of spare magazines, clamped to a maximum of 100 (adjustable)
var current_mags: int:
	set(value):
		value = clamp(value, 0, 100) # Prevent magazines from exceeding a reasonable limit
		current_mags = value
		sig_magazine_change.emit(current_mags) # Emit signal to update UI or other systems

# Maximum ammo per magazine
@export var capacity: int
# Total number of spare magazines
@export var max_magazines: int
#Time needed to reload
@export var time_needed_to_reload: float
# Timer node used to manage reload durations
@export var reload_timer: Timer

# Enumeration to track the state of the magazine (READY or RELOADING)
enum magazine_state { READY, RELOADING }
var current_magazine_state: magazine_state = magazine_state.READY

# Initialization logic when the node is added to the scene
func _ready() -> void:
	if reload_timer:
		reload_timer.timeout.connect(_on_reload_timer_timeout) # Connect reload completion event
	else:
		print("Warning: Reload timer is not assigned!")

	# Initialize ammo and spare magazines using deferred call to ensure UI updates correctly
	call_deferred("_initialize_ammo")

# Deferred initialization for ammo and magazine values
func _initialize_ammo() -> void:
	current_ammo = capacity # Set initial ammo to max capacity
	current_mags = max_magazines # Set initial magazines to the configured amount
	sig_ammo_change.emit(current_ammo) # Emit signal to update UI
	sig_magazine_change.emit(current_mags) # Emit signal to update UI

# Retrieve a projectile if ammo is available and the weapon is ready to fire
func get_projectile() -> PackedScene:
	if current_magazine_state == magazine_state.READY: # Ensure weapon is not reloading
		if current_ammo > 0: # Check if there is ammo available
			current_ammo -= 1 # Decrement ammo count
			return projectile # Return the projectile for firing
		else:
			print("Out of ammo") # Notify if no ammo is left
			return null
	else:
		print("Cannot fire while reloading!") # Notify if attempting to fire while reloading
		return null

# Initiate the reloading process
func reload():
	if current_magazine_state == magazine_state.RELOADING: # Prevent duplicate reload calls
		print("Already reloading.")
		return
	
	if current_mags <= 0: # Check if there are spare magazines available
		print("Out of magazines")
		return
	
	reload_timer.start(time_needed_to_reload) # Start the reload timer
	current_magazine_state = magazine_state.RELOADING # Set state to RELOADING

# Handle logic when the reload timer finishes
func _on_reload_timer_timeout():
	current_mags -= 1 # Deduct one magazine from the total
	current_ammo = capacity # Refill ammo to maximum capacity
	current_magazine_state = magazine_state.READY # Set state back to READY

func _emit_ui_singnals():
	sig_ammo_change.emit(current_ammo)
	sig_magazine_change.emit(current_mags)
