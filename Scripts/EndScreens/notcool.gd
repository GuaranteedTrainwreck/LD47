extends StaticBody2D



func _ready():
	pass


func _on_NOTCOOL_input_event(viewport, event, shape_idx):
	if event.is_action_pressed("player_action") or event.is_action_pressed("player_select"):
		get_parent().get_tree().reload_current_scene()
		self.visible = false
