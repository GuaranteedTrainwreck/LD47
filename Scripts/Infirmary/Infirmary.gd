extends StaticBody2D

var onDuty = true
var selected = false

func _ready():
	pass

func _physics_process(delta):
	if selected:
		self.rotation_degrees = 180
	else:
		self.rotation_degrees = 0

func _on_Infirmary_input_event(viewport, event, shape_idx):
	if event.is_action_pressed("player_select") and get_parent().incidentsTotal > 0 and onDuty:
		selected = true
