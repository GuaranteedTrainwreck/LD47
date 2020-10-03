extends StaticBody2D


var selected = false
var beingCool = false

func _ready():
	pass

func _physics_process(delta):
	if selected:
		self.rotation_degrees = 180
	else:
		self.rotation_degrees = 0

func _on_Staffcabin_input_event(viewport, event, shape_idx):
	if event.is_action_pressed("player_select") and !beingCool:
		selected = true
		get_parent().get_node("HideScreen").visible = true
		$CabinTimer.set_wait_time(1)
		$CabinTimer.start()
		beingCool = true
	elif event.is_action_pressed("player_select") and beingCool:
		get_parent().get_node("HideScreen").visible = false
		selected = false
		beingCool = false
		$CabinTimer.stop()

func _on_CabinTimer_timeout():
	get_parent().coolness += 2
