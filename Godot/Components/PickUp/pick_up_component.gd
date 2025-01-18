extends Area2D
class_name PickUpComponent

var held_item: Item

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass


func _on_body_entered(body: Node2D) -> void:
	if body is Player:
		body.inventory.add_item(held_item)
		print("Trying to pick up: " + held_item.name)
