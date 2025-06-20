extends Control


# exports
@export var score_label : Label
@export var time_label : Label

@export var wave_label : Label

@export var health_label : Label

@export var objects_label : Label

@export var player : Player

@export var control_pause : Control

func _physics_process(delta: float) -> void:
	# labels
	score_label.text = "Score: " + str(Globals.score)
	time_label.text = "Time: " + str(snapped(Globals.playtime, 0.01)) + "s"
	
	wave_label.text = "Wave: " + str(Globals.wave)
	
	health_label.text = "Health: " + str(player.health)
	
	objects_label.text = "N_Objects: " + str(Globals.n_objects)
	
	# input
	if Input.is_action_just_pressed("pause"):
		toggle_pause()
	
	if Input.is_action_just_pressed("stop"):
		Engine.time_scale = 1.0 if !Globals.is_playing else 0.0
		Globals.is_playing = !Globals.is_playing


func toggle_pause() -> void:
	if !control_pause.visible:
		control_pause.open()
		Globals.is_playing = false
	else:
		control_pause.visible = false
		Globals.is_playing = true


func _on_pause_button_pressed() -> void:
	if !Globals.is_game_over:
		toggle_pause()
