extends CharacterBody2D


# stats
var health : float = 5.0
var damage : float = 10.0

var speed : float = 270.0

# exports
@export var animator : AnimationPlayer


func _ready() -> void:
	velocity.y = -speed

func _physics_process(delta: float) -> void:
	move_and_slide()


func take_damage(amount: float) -> void:
	health -= amount
	if health <= 0:
		animator.play("explode")
