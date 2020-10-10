extends StaticBody2D

#booleans
var blinking = false

#preloads
var deathArrow = load("res://Assets/Cursors/death.png")

#ON START
func _ready():
	$Arrival.play("arrival")

#AT RUNTIME
func _physics_process(delta):
#	trigger red light blinking
	if get_parent().deathsTotal > 0 and !blinking:
		$AnimatedSprite.play("blinking")
		blinking = true
	elif get_parent().deathsTotal < 1 and blinking:
		$AnimatedSprite.play("idle")
		blinking = false

#ON LEFT CLICK
func _on_ambulance_input_event(viewport, event, shape_idx):
	if event.is_action_pressed("player_select") and !get_parent().beingOnPhone:
		ClickAmbulance()

func ClickAmbulance():
	if get_parent().deathsTotal > 0 and get_parent().ambulanceReady and !get_parent().ambulanceClicked:
		$select.play()
		Input.set_custom_mouse_cursor(deathArrow)
		get_parent().ambulanceClicked = true
		$AnimatedSprite.get_material().set_shader_param("outline_width", 3)

#ambulance return
func _on_departure_animation_finished(anim_name):
	get_parent().ambulanceReady = true
	$Arrival.play("arrival")
	
