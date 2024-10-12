@tool
extends Node2D

@export_category("Debug")
@export var ojla:int = 12;
@export var mybutton: bool:
	set(value):
		print("ojlaaa")

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	var imported_resource = load("res://robi.png")
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
