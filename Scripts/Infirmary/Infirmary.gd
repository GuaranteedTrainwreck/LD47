extends StaticBody2D


var selected = false

func _ready():
	$Sprite.get_material().set_shader_param("outline_width", 0)

func _physics_process(delta):
	pass

func _on_Infirmary_input_event(viewport, event, shape_idx):
	if event.is_action_pressed("player_select") and !get_parent().beingOnPhone:
		ClickInfirmary()


func ClickInfirmary():
	selected = get_parent().healing

	if get_parent().incidentsTotal > 0 and !selected:
		selected = true
		$Sprite.get_material().set_shader_param("outline_width", 3)
	elif get_parent().incidentsTotal > 0 and selected:
		selected = false
		$Sprite.get_material().set_shader_param("outline_width", 0)

	get_parent().healing = selected
