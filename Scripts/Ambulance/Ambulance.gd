extends StaticBody2D

var ambulanceReady = true
var ambulanceClicked = false
var deathsTotal = 0
var blinking = false

func _ready():
	$Arrival.play("arrival")

func _physics_process(delta):
	deathsTotal = get_parent().deathsTotal
	ambulanceReady = get_parent().ambulanceReady
	ambulanceClicked = get_parent().ambulanceClicked
	
	if (deathsTotal > 0) and !blinking:
		$AnimatedSprite.play("blinking")
		blinking = true
	elif (deathsTotal < 1 and blinking):
		$AnimatedSprite.play("idle")
		blinking = false

func _on_ambulance_input_event(viewport, event, shape_idx):
	if event.is_action_pressed("player_select") and !get_parent().beingOnPhone:
		ClickAmbulance()

func ClickAmbulance():
	if get_parent().deathsTotal > 0 and ambulanceReady and !ambulanceClicked:
		get_parent().ambulanceClicked = true
		$AnimatedSprite.get_material().set_shader_param("outline_width", 3)

func _on_departure_animation_finished(anim_name):
	get_parent().ambulanceReady = true
	$Arrival.play("arrival")
	
