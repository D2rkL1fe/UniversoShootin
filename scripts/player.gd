extends CharacterBody2D
class_name Player


# stats
var max_health : float = 100.0
var health : float = 100.0

var damage : float = 10.0

var speed: float = 220.0

var n_bullets : int = 1

# shooting stats
var fire_speed : float = 0.25
var fire_timer : float = 0.0

var is_firing : bool = false

# exports
@export var camera : MainCamera

@export var bullet : PackedScene

@export var fire_audio : AudioStreamPlayer

@export var fire_point : Node2D

@export var hit_audio : AudioStreamPlayer

@export var animator : AnimationPlayer

@export var background_tint : TextureRect
@export var control_lost : ControlLost

# current
var direction : float


func _physics_process(delta: float) -> void:
	# fire timer
	if is_firing:
		fire_timer += delta
	if fire_timer >= fire_speed:
		is_firing = false
		fire_timer -= fire_speed
	
	# main
	if Globals.is_playing:
		# shooting
		if Input.is_action_pressed("shoot") and !is_firing:
			fire()
	
		# movement
		direction = Input.get_axis("left", "right")
	
	velocity.x = lerp(velocity.x, speed * direction, 2.0 * delta)
	
	rotation = velocity.x / 1000
	
	move_and_slide()
	
	# clamp position
	position.x = clamp(position.x, -232, 232)


func take_damage(amount: float) -> void:
	health = max(0.0, health - amount)
	if health <= 0:
		if !Globals.is_game_over:
			background_tint.visible = true
			
			control_lost.lost_screen()
		
		Globals.is_game_over = true
	
	hit_audio.play()
	camera.start_shaking()
	animator.play("hit")

func fire() -> void:
	var n_offset = 5.0
	for i in range(n_bullets):
		# create bullet
		var instance = bullet.instantiate()
		
		var x_offset = n_offset * i - ((n_offset / 2) * (n_bullets - 1))
		var y_offset = abs(x_offset * x_offset) * 0.005
		
		instance.global_position = fire_point.global_position + Vector2(x_offset, y_offset)
		
		get_parent().add_child(instance)
	
	# play sound
	fire_audio.play()
	
	# start timer
	is_firing = true


func _on_hurtbox_body_entered(body: Node2D) -> void:
	if body.is_in_group("EnemyBullet"):
		take_damage(body.damage)
		
		body.take_damage(5.0)
