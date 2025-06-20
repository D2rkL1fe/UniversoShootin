extends Node2D 
class_name VelocityComponent


# exports
@export var speed : float = 60.0
@export var direction : Vector2 = Vector2(0.0, 1.0)

@export var body : CharacterBody2D

func _ready() -> void:
	body.velocity = speed * direction


func _physics_process(delta: float) -> void:
	body.move_and_slide()
