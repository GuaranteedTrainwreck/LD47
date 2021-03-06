extends StaticBody2D

var infirmaryClicked = false
var incidentsTotal = 0
var blinking = false
var healArrow = load("res://Assets/Cursors/heal.png")

func _ready():
	$AnimatedSprite.get_material().set_shader_param("outline_width", 0)

func _physics_process(delta):
	incidentsTotal = get_parent().incidentsTotal
	infirmaryClicked = get_parent().infirmaryClicked
	
	if (incidentsTotal > 0) and !blinking:
		$AnimatedSprite.play("blinking")
		blinking = true
	elif (incidentsTotal < 1 and blinking):
		$AnimatedSprite.play("idle")
		blinking = false
	

func _on_Infirmary_input_event(viewport, event, shape_idx):
	if event.is_action_pressed("player_select") and !get_parent().beingOnPhone:
		ClickInfirmary()


func ClickInfirmary():
	if get_parent().incidentsTotal > 0 and !infirmaryClicked:
		$select.play()
		Input.set_custom_mouse_cursor(healArrow)
		get_parent().onDuty = get_parent().medicsMax
		infirmaryClicked = true
		get_parent().infirmaryClicked = infirmaryClicked
		$AnimatedSprite.get_material().set_shader_param("outline_width", 3)
	elif get_parent().incidentsTotal > 0 and infirmaryClicked:
		Input.set_custom_mouse_cursor(null)
		get_parent().onDuty = 0
		infirmaryClicked = false
		get_parent().infirmaryClicked = infirmaryClicked
		$AnimatedSprite.get_material().set_shader_param("outline_width", 0)
