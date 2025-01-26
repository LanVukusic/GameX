@tool
extends Node2D

@export_category("Time slider")
@export_range(0, 1) var time: float
@export var enable_time_tracking: bool = false

@export_category("Daytime manager")
@export var color_gradient: Gradient
@export var ambient_light_curve: Curve

@export_category("Component access")
@export var ambient_light: DirectionalLight2D
@export var dayTimer: Timer

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _physics_process(delta: float) -> void:
	# set time accoring to timer
	if (enable_time_tracking):
		var day_length = dayTimer.wait_time
		var day_fraction = (day_length - dayTimer.time_left) / day_length
		time = day_fraction

	ambient_light.energy = ambient_light_curve.sample(time)
	ambient_light.color = color_gradient.sample(time)
