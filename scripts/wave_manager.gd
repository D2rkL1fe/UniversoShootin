extends Node2D


# per n waves
var waves_until_obstacles: int = 1
var waves_until_enemies: int = 2
var waves_until_power_ups: int = 5

# per wave
var obstacles_per_wave : int = 10
var enemies_per_wave : int = 2

var power_ups_per_wave : int = 1

# increase per n waves
var increase_obstacles_per_n_waves : int = 5
var increase_enemies_per_n_waves : int = 10
var increase_power_ups_per_n_waves : int = 25

# increase amount
var increase_obstacles_amount : int = 5
var increase_enemies_amount : int = 2
var increase_power_ups_amount : int = 1

# max amount
var max_obstacles_amount : int = 75
var max_enemies_amount : int = 25
var max_power_ups_amount : int = 5

# first appereance
var obstacles_first_wave : int = 0
var enemies_first_wave : int = 5
var power_ups_first_wave : int = 0

# more variety after n waves
var obstacles_variety_per_n_waves : int = 5
var enemies_variety_per_n_waves : int = 10
var power_ups_variety_per_n_waves : int = 10

# exports
@export var obstacles : Array[PackedScene]
@export var enemies : Array[PackedScene]

@export var power_ups : Array[PackedScene]

@export var spawn_timer : Timer
@export var intermission_timer : Timer

# visual
@export var wave_label : Label
@export var animator : AnimationPlayer

# current
var obstacles_variety : int = 1
var enemies_variety : int = 1
var power_ups_variety : int = 1

# everything
var objects = []

var spawn_time : float = 5.0 # in seconds

var wave_finished = true


func _physics_process(delta: float) -> void:
	if wave_finished and Globals.n_objects <= 0:
		wave_finished = false
		
		intermission_timer.start()


func add_obstacle():
	var rand_obstacle = randi_range(0, obstacles_variety)
	var instance = obstacles[rand_obstacle].instantiate()
	
	instance.global_position = Vector2(randf_range(-240, 240), -165)
	
	instance.health *= difficulty_multiplier(Globals.wave)
	instance.score_amount *= difficulty_multiplier(Globals.wave) 
	
	objects.push_back(instance)

func add_enemy():
	var rand_enemy = randi_range(0, enemies_variety)
	var instance = enemies[rand_enemy].instantiate()
	
	instance.global_position = Vector2(randf_range(-240, 240), -165)
	
	instance.health *= difficulty_multiplier(Globals.wave)
	instance.score_amount *= difficulty_multiplier(Globals.wave) 
	
	objects.push_back(instance)

func add_power_up():
	var rand_power_up = randi_range(0, power_ups_variety)
	var instance = power_ups[rand_power_up].instantiate()
	
	instance.global_position = Vector2(randf_range(-240, 240), -165)
	
	objects.push_back(instance)

func difficulty_multiplier(n_wave: int) -> float:
	var multiplier = clamp(n_wave / 25, 1, 100)
	
	return multiplier

func _on_spawn_timer_timeout() -> void:
	# spawn
	if objects.size() > 0:
		add_child(objects[0])
		objects.pop_front()
		
		spawn_timer.start()
	else:
		wave_finished = true


func next_wave() -> void:
	Globals.wave += 1
	
	# variety
	obstacles_variety = clamp(snapped(Globals.wave / obstacles_variety_per_n_waves, 1), 0, obstacles.size() - 1)
	enemies_variety = clamp(snapped(Globals.wave / enemies_variety_per_n_waves, 1), 1, enemies.size() - 1)
	power_ups_variety = clamp(snapped(Globals.wave / power_ups_variety_per_n_waves, 1), 1, power_ups.size() - 1)
	
	# add
	if Globals.wave % waves_until_obstacles == 0:
		var n_obstacles = obstacles_per_wave + (snapped(Globals.wave / increase_obstacles_per_n_waves, 1) * increase_obstacles_amount)
		
		n_obstacles = min(n_obstacles, max_obstacles_amount)
		for i in range(n_obstacles):
			add_obstacle()
	
	if Globals.wave % waves_until_enemies == 0 and Globals.wave >= enemies_first_wave:
		var n_enemies = enemies_per_wave + (snapped(Globals.wave / increase_enemies_per_n_waves, 1) * increase_enemies_amount)
		
		n_enemies = min(n_enemies, max_enemies_amount)
		for i in range(n_enemies):
			add_enemy()
	
	if Globals.wave % waves_until_power_ups == 0:
		var n_power_ups = power_ups_per_wave + (snapped(Globals.wave / increase_power_ups_per_n_waves, 1) * increase_power_ups_amount)
		
		n_power_ups = min(n_power_ups, max_power_ups_amount)
		for i in range(n_power_ups):
			add_power_up()
	
	# spawn
	wave_label.text = "Wave " + str(Globals.wave)
	animator.play("next_wave")
	
	spawn_timer.wait_time = spawn_time / objects.size()
	
	spawn_timer.start()


func _on_intermission_timer_timeout() -> void:
	next_wave()
