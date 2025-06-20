extends CharacterBody2D


@export var animator : AnimationPlayer

var player : Player

func _ready() -> void:
	player = get_tree().get_nodes_in_group("Player")[0]
	
	Globals.n_objects += 1

func add_bullet():
	player.n_bullets += 1

func _on_hurtbox_body_entered(body: Node2D) -> void:
	if body.is_in_group("Player"):
		add_bullet()
		
		Globals.n_objects -= 1
		
		animator.play("collect")
