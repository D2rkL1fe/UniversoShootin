extends Area2D


func _on_area_entered(area: Area2D) -> void:
	if area.get_parent() is Obstacle or area.is_in_group("PowerUp"):
		Globals.n_objects -= 1
	
	area.get_parent().queue_free()


func _on_body_entered(body: Node2D) -> void:
	body.queue_free()
