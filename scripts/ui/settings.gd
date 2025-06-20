extends Control


# exports
@export var target : Control

@export var check_sfx : CheckBox
@export var check_music : CheckBox

@export var slider_sfx : HSlider
@export var slider_music : HSlider

# input settings
@export var input_button : PackedScene
@export var action_list : VBoxContainer

var is_remapping : bool = false
var action_to_remap = null
var remapping_button : InputButton = null

var input_actions : Dictionary = {
	"left": "Left",
	"right": "Right",
	"shoot": "Shoot",
}


func open() -> void:
	visible = true
	
	# audio
	check_sfx.button_pressed = !AudioServer.is_bus_mute(1)
	check_music.button_pressed = !AudioServer.is_bus_mute(2)
	
	slider_sfx.value = AudioServer.get_bus_volume_db(1)
	slider_music.value = AudioServer.get_bus_volume_db(2)
	
	# input
	create_action_list(false)


func create_action_list(reset_to_default: bool):
	if reset_to_default:
		InputMap.load_from_project_settings()
	
	for item in action_list.get_children():
		item.queue_free()
	
	for action in input_actions:
		var button : InputButton = input_button.instantiate()
		
		var action_label : Label = button.action_label
		var input_label : Label = button.input_label
		
		action_label.text = input_actions[action]
		
		var events : Array[InputEvent] = InputMap.action_get_events(action)
		if events.size() > 0:
			input_label.text = events[0].as_text().trim_suffix(" (Physical)")
		else:
			input_label.text = ""
		
		action_list.add_child(button)
		button.pressed.connect(_on_input_button_pressed.bind(button, action))

func _on_input_button_pressed(button: InputButton, action: String):
	if !is_remapping:
		is_remapping = true
		
		action_to_remap = action
		remapping_button = button
		
		button.input_label.text = "Press key to bind..."

func _input(event: InputEvent) -> void:
	if is_remapping:
		if event is InputEventKey || event is InputEventMouseButton && event.pressed:
			# turn double click into singularity
			if event is InputEventMouseButton && event.double_click:
				event.double_click = false
			
			InputMap.action_erase_events(action_to_remap)
			InputMap.action_add_event(action_to_remap, event)
			
			update_action_list(remapping_button, event)
			
			is_remapping = false
			action_to_remap = null
			remapping_button = null
			
			accept_event()

func update_action_list(button: InputButton, event: InputEvent):
	button.input_label.text = event.as_text().trim_suffix(" (Physical)")


func _on_return_button_pressed() -> void:
	visible = false
	
	target.open_main()


func _on_check_sfx_toggled(toggled_on: bool) -> void:
	AudioServer.set_bus_mute(1, !toggled_on)


func _on_check_music_toggled(toggled_on: bool) -> void:
	AudioServer.set_bus_mute(2, !toggled_on)


func _on_slider_sfx_value_changed(value: float) -> void:
	AudioServer.set_bus_volume_db(1, value)


func _on_slider_music_value_changed(value: float) -> void:
	AudioServer.set_bus_volume_db(2, value)


func _on_reset_button_pressed() -> void:
	create_action_list(true)
