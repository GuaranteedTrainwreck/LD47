extends StaticBody2D

var onDuty = true
var selected = false

func _ready():
	$Sprite.get_material().set_shader_param("outline_width", 0)

func _physics_process(delta):
	pass

func _on_Infirmary_input_event(viewport, event, shape_idx):
	if event.is_action_pressed("player_select") and get_parent().incidentsTotal > 0 and onDuty:
		selected = true
		$Sprite.get_material().set_shader_param("outline_width", 3)
