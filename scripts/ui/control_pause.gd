extends Control


# exports
@export var target : Control

@export var check_sfx : CheckBox
@export var check_music : CheckBox

@export var slider_sfx : HSlider
@export var slider_music : HSlider


func open() -> void:
	visible = true
	
	check_sfx.button_pressed = !AudioServer.is_bus_mute(1)
	check_music.button_pressed = !AudioServer.is_bus_mute(2)
	
	slider_sfx.value = AudioServer.get_bus_volume_db(1)
	slider_music.value = AudioServer.get_bus_volume_db(2)


func _on_check_sfx_toggled(toggled_on: bool) -> void:
	AudioServer.set_bus_mute(1, !toggled_on)


func _on_check_music_toggled(toggled_on: bool) -> void:
	AudioServer.set_bus_mute(2, !toggled_on)


func _on_slider_sfx_value_changed(value: float) -> void:
	AudioServer.set_bus_volume_db(1, value)


func _on_slider_music_value_changed(value: float) -> void:
	AudioServer.set_bus_volume_db(2, value)


func _on_resume_button_pressed() -> void:
	Globals.is_playing = true
	visible = false


func _on_menu_button_pressed() -> void:
	get_tree().change_scene_to_file("res://scenes/ui/menu.tscn")
