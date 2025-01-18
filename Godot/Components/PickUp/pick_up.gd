@tool
extends Node2D

@onready var pick_up: PickUpComponent = $PickUpComponent

@export var item: Item:
	set(value):
		item = value
		if Engine.is_editor_hint():
			_init_item_visuals()

@onready var sprite: Sprite2D = %Sprite2D

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	_init_item_visuals()
	pick_up.held_item = item #pass item reference

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass


func _init_item_visuals():
	if item:
		sprite.texture = item.sprite
