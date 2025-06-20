extends Control


# exports
@export var main : Control
@export var settings : Control
@export var statistics : Control
@export var leaderboard : Control

@export var high_score_label : Label


func _ready() -> void:
	open_main()

func open_main() -> void:
	main.visible = true
	
	high_score_label.text = "High Score: " + str(Globals.high_score)


func _on_start_button_pressed() -> void:
	Globals.restart()


func _on_settings_button_pressed() -> void:
	main.visible = false
	
	settings.open()


func _on_statistics_button_pressed() -> void:
	main.visible = false
	
	statistics.open()


func _on_leaderboard_button_pressed() -> void:
	main.visible = false
	
	Leaderboard.open(main)
