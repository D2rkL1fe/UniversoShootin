extends CharacterBody2D
class_name Obstacle


# stats
@export var health : float = 30.0
@export var damage : float = 10.0

@export var speed : float = 70.0

@export var score_amount : int = 500.0

# exports
@export var hit_audio : AudioStreamPlayer
@export var explode_audio : AudioStreamPlayer

@export var animator : AnimationPlayer

# extra
var rotation_speed : float = randf_range(-1, 1)


func _ready() -> void:
	velocity.y = speed + randf_range(-15.0, 15.0)
	
	Globals.n_objects += 1

func _physics_process(delta: float) -> void:
	rotation += rotation_speed * delta
	
	move_and_slide()


func take_damage(amount: float) -> void:
	health -= amount
	if health <= 0:
		Globals.add_score(score_amount)
		
		Globals.n_objects -= 1
		
		animator.play("explode")
	
	# if not destroyed
	hit_audio.play()


func _on_hurtbox_body_entered(body: Node2D) -> void:
	if body.is_in_group("Bullet"):
		take_damage(body.damage)
		
		body.take_damage(damage)
	
	if body.is_in_group("Player"):
		Globals.n_objects -= 1
		
		animator.play("explode")
		
		body.take_damage(damage)
