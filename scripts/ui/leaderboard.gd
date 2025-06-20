extends CanvasLayer


# exports
@export var grid : GridContainer

@export var loading_label : Label
@export var empty_label : Label

# current
var is_updating : bool = false

var target : Control


func _ready() -> void:
	visible = false
	
	create_leaderboard()

func create_leaderboard() -> void:
	# skip
	if is_updating:
		return
	
	# clear grid
	for item in range(3, grid.get_child_count()):
		grid.get_child(item).queue_free()
	
	# set up
	grid.get_parent().visible = false
	empty_label.visible = false
	
	loading_label.visible = true
	is_updating = true
	
	# get data
	var sw_result : Dictionary = await SilentWolf.Scores.get_scores(20).sw_get_scores_complete
	
	loading_label.visible = false
	is_updating = false
	
	# create labels with according data
	if sw_result.is_empty():
		empty_label.visible = true
	else:
		grid.get_parent().visible = true
		
		var rank = 1
		for score in sw_result.scores:
			# create labels
			var rank_label : Label = Label.new()
			var name_label : Label = Label.new()
			var score_label : Label = Label.new()
			
			# set text
			rank_label.text = str(rank)
			name_label.text = score.player_name
			score_label.text = str(snapped(score.score, 1))
			
			# add labels
			grid.add_child(rank_label)
			grid.add_child(name_label)
			grid.add_child(score_label)
			
			# iterate rank further
			rank += 1

func open(target_node: Control) -> void:
	visible = true
	
	target = target_node
	
	create_leaderboard()

func _on_close_button_pressed() -> void:
	visible = false
	
	target.visible = true
