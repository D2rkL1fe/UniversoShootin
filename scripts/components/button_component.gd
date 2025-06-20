extends Node


# exports
@export var hover_audio : AudioStreamPlayer
@export var press_audio : AudioStreamPlayer

# current
var button : Button


func _ready() -> void:
	button = get_parent() as Button
	
	button.focus_mode = Control.FOCUS_NONE
	
	button.mouse_entered.connect(_on_hover)
	button.pressed.connect(_on_press)


func _on_hover() -> void:
	if !button.disabled:
		hover_audio.play()

func _on_press() -> void:
	if is_inside_tree():
		press_audio.play()
