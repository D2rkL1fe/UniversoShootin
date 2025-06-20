extends CharacterBody2D


# stats
var health : float = 30.0

var speed : float = 10.0

var score_amount : int = 750

# exports
@export var enemy_bullet : PackedScene

@export var fire_timer : Timer
@export var fire_point : Node2D

@export var animator : AnimationPlayer

@export var shapecast : ShapeCast2D

# current
var player : Player


func _ready() -> void:
	player = get_parent().get_parent().get_node("Player")
	
	Globals.n_objects += 1


func _physics_process(delta: float) -> void:
	velocity.y = lerp(velocity.y, -96.0 - position.y, 2.0 * delta)
	
	velocity.x = lerp(velocity.x, player.position.x - position.x, 16.0 * delta)
	rotation = -velocity.x / 1000
	
	move_and_slide()


func take_damage(amount: float) -> void:
	health -= amount
	if health <= 0:
		Globals.add_score(score_amount)
		
		Globals.n_objects -= 1
		
		animator.play("explode")
	else:
		animator.play("hit")


func _on_hurtbox_body_entered(body: Node2D) -> void:
	if body.is_in_group("Bullet"):
		take_damage(body.damage)
		
		body.take_damage(5.0)


func fire():
	var instance = enemy_bullet.instantiate()
	
	instance.global_position = fire_point.global_position
	
	get_parent().add_child(instance)

func _on_fire_timer_timeout() -> void:
	if !shapecast.is_colliding():
		fire()
