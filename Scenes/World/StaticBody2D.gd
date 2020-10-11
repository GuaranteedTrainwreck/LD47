extends StaticBody2D

var bosstalk = true
var stafftalk = true

func _ready():
	pass



func _on_StaticBody2D_input_event(viewport, event, shape_idx):
	if event.is_action_pressed("player_select") and !bosstalk and !stafftalk:
		get_parent().visible = false
		get_parent().get_node("banneranim").stop()
