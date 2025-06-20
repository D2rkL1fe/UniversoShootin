extends Control


# exports
@export var target : Control

@export var high_score_label : Label
@export var total_playtime_label : Label
@export var highest_wave_label : Label


func open() -> void:
	visible = true
	
	# labels
	high_score_label.text = "High Score: " + str(Globals.high_score)
	
	total_playtime_label.text = "Total Playtime: " + str(snapped(Globals.total_playtime, 0.01)) + "s"
	
	highest_wave_label.text = "Highest Wave: " + str(Globals.highest_wave)


func _on_return_button_pressed() -> void:
	visible = false
	
	target.open_main()


func _on_reset_button_pressed() -> void:
	# reset globals
	Globals.high_score = 0
	Globals.total_playtime = 0.0
	Globals.highest_wave = 0
	
	# save
	var game_save : SaveGame = SaveGame.new()
	
	game_save.high_score = 0
	game_save.total_playtime = 0.0
	game_save.highest_wave = 0
	
	game_save.write_savegame()
	
	# reload page
	open()
