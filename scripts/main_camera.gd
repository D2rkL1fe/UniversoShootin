extends Camera2D
class_name MainCamera


# stats
var shake_power = 7.5
var n_shakes = 8

var current_shakes = 0

# exports
@export var shake_timer : Timer


func start_shaking():
	current_shakes = 0
	
	shake_timer.start()


func _on_shake_timer_timeout() -> void:
	# shake
	position = Vector2(randf_range(-shake_power, shake_power), randf_range(-shake_power, shake_power))
	
	# shake loop
	current_shakes += 1
	
	if current_shakes < n_shakes:
		shake_timer.start()
	else:
		position = Vector2(0, 0)
