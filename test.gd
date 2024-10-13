extends Node2D


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	var n2d = Node2D.new()
	n2d.visible = true
	self.add_child(n2d)
	pass # Replace with function body.
	


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
