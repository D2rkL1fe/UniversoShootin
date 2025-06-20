extends Area2D


func _on_area_entered(area: Area2D) -> void:
	var body = area.get_parent()
	if body.is_in_group("Obstacle"):
		body.queue_free()
