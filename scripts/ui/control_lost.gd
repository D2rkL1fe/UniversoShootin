extends Control
class_name ControlLost


# all time
@export var high_score_label : Label
@export var total_playtime_label : Label
@export var highest_wave_label : Label

# main
@export var score_label : Label
@export var time_label : Label
@export var wave_label : Label

@export var new_high_score_label : Label

# competion
@export var vbox_input : VBoxContainer

@export var name_input : LineEdit
@export var error_label : Label
@export var submit_button : Button

@export var submitted_label : Label

func lost_screen():
	Globals.stop()
	
	visible = true
	
	# check for new records
	if Globals.check_records():
		new_high_score_label.visible = true
	
	# all time labels
	high_score_label.text = "High Score: " + str(Globals.high_score)
	total_playtime_label.text = "Total Playtime: " + str(snapped(Globals.total_playtime, 0.01)) + "s"
	highest_wave_label.text = "Highest Wave: " + str(Globals.highest_wave)
	
	# labels
	score_label.text = "Total Score: " + str(Globals.score)
	time_label.text = "Playtime: " + str(snapped(Globals.playtime, 0.01)) + "s"
	wave_label.text = "Wave: " + str(Globals.wave)


func _on_try_again_button_pressed() -> void:
	Globals.restart()


func _on_menu_button_pressed() -> void:
	get_tree().change_scene_to_file("res://scenes/ui/menu.tscn")


func _on_name_input_text_changed(new_text: String) -> void:
	if len(new_text) < 3:
		error_label.visible = true
		submit_button.disabled = true
		
		return
	else:
		error_label.visible = false
		submit_button.disabled = false
		
		Globals.player_name = new_text


func _on_submit_button_pressed() -> void:
	vbox_input.visible = false
	
	submitted_label.visible = true
	
	SilentWolf.Scores.save_score(Globals.player_name, Globals.score)


func _on_leaderboard_button_pressed() -> void:
	visible = false
	
	Leaderboard.open(self)
