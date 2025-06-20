extends Node


# non stats
var player_name : String = "Player#7777"

# all time stats
var high_score : int = 0

var total_playtime : float = 0.0

var highest_wave : int = 0

# session stats
var score : int = 0
var playtime : float = 0.0

var wave : int = 0

var is_playing : bool = false

var is_game_over : bool = false

# for debuggin' ( IMPORTANT! )
var n_objects = 0


func _ready() -> void:
	# silent *hill* wolf
	SilentWolf.configure({
		"api_key": "aFppub1DFN1PPkb5xEtl49xp0MthRqO168UyeSZw",
		"game_id": "universoshootin",
		"log_level": 1,
	})
	
	SilentWolf.configure_scores({
		"open_scene_on_close": "res://scenes/menu.tscn"
	})
	
	# load data
	var data = SaveGame.load_savegame()
	
	if data:
		high_score = data.high_score
		total_playtime = data.total_playtime
		highest_wave = data.highest_wave


func _physics_process(delta: float) -> void:
	if is_playing:
		Engine.time_scale = lerp(Engine.time_scale, 1.0, 8.0 * delta)
		
		if !is_game_over:
			playtime += delta
	else:
		Engine.time_scale = lerp(Engine.time_scale, 0.0, 8.0 * delta)

	n_objects = max(n_objects, 0)

func restart():
	score = 0
	playtime = 0.0
	
	wave = 0
	
	n_objects = 0
	
	is_playing = true
	is_game_over = false
	
	get_tree().change_scene_to_file("res://scenes/world.tscn")

func stop():
	is_playing = false


func add_score(amount: int):
	if !is_game_over:
		score += amount


func check_records():
	var new_record = false

	# score
	if high_score < score:
		high_score = score
		
		new_record = true
	
	# add playtime
	total_playtime += playtime
	
	# wave
	if highest_wave < wave:
		highest_wave = wave
	
	# save game
	var game_save : SaveGame = SaveGame.new()
	
	game_save.high_score = high_score
	game_save.total_playtime = total_playtime
	game_save.highest_wave = highest_wave
	
	game_save.write_savegame()
	
	return new_record
