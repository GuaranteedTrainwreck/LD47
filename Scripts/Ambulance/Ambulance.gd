extends StaticBody2D

var ambulanceReady = true
var ambulanceClicked = false

func _ready():
	$Arrival.play("arrival")

func _physics_process(delta):
	ambulanceReady = get_parent().ambulanceReady
	ambulanceClicked = get_parent().ambulanceClicked

func _on_ambulance_input_event(viewport, event, shape_idx):
	if event.is_action_pressed("player_select") and !get_parent().beingOnPhone:
		ClickAmbulance()

func ClickAmbulance():
	if get_parent().deathsTotal > 0 and ambulanceReady and !ambulanceClicked:
		get_parent().ambulanceClicked = true
		self.rotation_degrees = 180

func _on_departure_animation_finished(anim_name):
	print("yes")
	get_parent().ambulanceReady = true
	self.rotation_degrees = 0	
	$Arrival.play("arrival")
	
