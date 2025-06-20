class_name SaveGame
extends Resource

const SAVE_GAME_PATH := "user://savegame.tres"

@export var player_name : String = "PlayerShootin"

@export var high_score : int = 0
@export var total_playtime : float = 0.0
@export var highest_wave : int = 0

func write_savegame() -> void:
	ResourceSaver.save(self, SAVE_GAME_PATH)

static func load_savegame() -> Resource:
	if ResourceLoader.exists(SAVE_GAME_PATH):
		return load(SAVE_GAME_PATH)
	return null
