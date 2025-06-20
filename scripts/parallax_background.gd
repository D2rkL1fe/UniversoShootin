extends ParallaxBackground


var speed : float = 100.0


func _physics_process(delta: float) -> void:
	scroll_base_offset.x += speed * delta
	scroll_base_offset.y += speed * 0.5 * delta
