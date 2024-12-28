extends Node2D

@export var zergling_scene: PackedScene

@onready var spawner_component: SpawnerComponent = $SpawnerComponent
@onready var zergling_spawner_timer: Timer = $ZerglingSpawnerTimer

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	zergling_spawner_timer.timeout.connect(handle_spawn.bind(zergling_scene, zergling_spawner_timer))
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass

func handle_spawn(enemy_scene: PackedScene, timer: Timer) -> void:
	spawner_component.scene = enemy_scene
	spawner_component.spawn(self.global_position)
	timer.start()
	pass
