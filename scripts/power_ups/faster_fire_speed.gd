extends CharacterBody2D


@export var animator : AnimationPlayer

var player : Player

func _ready() -> void:
	player = get_tree().get_nodes_in_group("Player")[0]
	
	Globals.n_objects += 1

func decrease_fire_speed():
	player.fire_speed *= 0.75

func _on_hurtbox_body_entered(body: Node2D) -> void:
	if body.is_in_group("Player"):
		decrease_fire_speed()
		
		Globals.n_objects -= 1
		
		animator.play("collect")
