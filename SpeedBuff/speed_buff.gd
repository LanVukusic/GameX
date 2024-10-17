extends Area2D

@export var boost_speed = 800       # Boosted speed for the player
@export var boost_duration = 5      # Duration of the boost in seconds

# Called when a body (e.g., the player) enters the item's collision area
func _on_body_entered(body):
	if body.is_in_group("Player"):  # Check if the body is the player
		var player = body            # Reference to the player
		var original_speed = player.speed  # Get the player's current speed

		# Apply speed boost to the player
		player.speed = boost_speed
		
		# Start a timer to reset the speed after boost_duration seconds
		var reset_timer = Timer.new()
		reset_timer.one_shot = true
		reset_timer.wait_time = boost_duration
	
		add_child(reset_timer)  # Add the timer to the scene
		reset_timer.start()     # Start the timer

		# Remove the item from the game world after pickup
		queue_free()

# Function to reset the player's speed back to normal after the boost duration
func _on_boost_timeout(player, original_speed):
	# Debugging step: check if player and original_speed are correct
	print("Boost ended! Resetting speed.")
	
	player.speed = original_speed  # Reset the player's speed back to normal
