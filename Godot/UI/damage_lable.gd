extends Label

func setup(amount: int):
	text = str(amount)
	
	# Randomize position slightly so they don't stack perfectly
	position.x += randf_range(-20, 20)
	position.y += randf_range(-10, 10)

func _ready():
	# Visual flair: Red color
	modulate = Color(1, 0.2, 0.2, 1) 
	
	var tween = create_tween()
	tween.set_parallel(true)
	
	# FIX: Separate TRANS_CUBIC and EASE_OUT
	tween.tween_property(self, "position:y", position.y - 50, 0.8)\
		.set_trans(Tween.TRANS_CUBIC)\
		.set_ease(Tween.EASE_OUT)
	
	tween.tween_property(self, "modulate:a", 0.0, 0.8)\
		.set_ease(Tween.EASE_IN)
	
	# Delete self after animation
	tween.chain().tween_callback(queue_free)
