extends Node2D
class_name StatusEffectBase

signal sig_status_end(effect: StatusEffectBase)

var target: StatusEffectHandler
var tick_count: int = 0
var stack_count: int = 0


#relevant_exported_variables(could be moved in the future)
@export_category("General")
@export var type: String
@export var max_ticks: int
@export var max_stacks: int
@export var can_refresh: bool = true #Whether to refresh duration on stacking
@export_category("Timers")
#Timers private
@export var tick_timer: Timer

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass


func apply(status_effect_handler: StatusEffectHandler):
	add_stack()
	target = status_effect_handler
	target.add_child(self)
	tick_count = 0 # reset status effect duration


func process_effect():
	pass


func _on_tick_timer_timeout():
	process_effect()
	tick_count += 1
	print("Removed a tick! Tick count is " + str(tick_count))
	
	if tick_count >= max_ticks:
		print_debug("Effect ended. Cleaing up")
		_remove_status()


func _remove_status():
	sig_status_end.emit(self)
	self.queue_free()


func _create_timer(wait_time: float, one_shot: bool, callback: Callable) -> Timer:
	var timer = Timer.new()
	timer.one_shot = one_shot
	timer.timeout.connect(callback)
	target.add_child(timer)
	timer.start(wait_time)
	return timer


func refresh_duration():
	add_stack()
	tick_count = 0 


func add_stack():
	if stack_count < max_stacks:
		stack_count += 1
		print("Stack added. Current stack count: " + str(tick_count))
	else:
		print("Max stacks reached. Current stack count: " + str(tick_count))
