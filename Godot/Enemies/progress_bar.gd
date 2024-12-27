extends ProgressBar

@export var health_component: HealthComponent

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	self.max_value = health_component.max_health
	self.value = health_component.max_health
	health_component.sig_health_changed.connect(change_bar)
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass

func change_bar(hp: int):
	self.value = hp
