extends StaticBody2D


var selected = false
var beingCool = false

func _ready():
	pass

#func _physics_process(delta):
#	if selected:
#		self.rotation_degrees = 180
#	else:
#		self.rotation_degrees = 0

func _on_Staffcabin_input_event(viewport, event, shape_idx):
	if event.is_action_pressed("player_select") and !beingCool:
		selected = true
		$CabinTimer.set_wait_time(1)
		$CabinTimer.start()
		beingCool = true
		$AnimationPlayer.play("selected")
		get_parent().get_node("Clouds").visible = true
		get_parent().get_node("talkinghead").visible = true
		get_parent().get_node("BeingCool").play("smoke")
	elif event.is_action_pressed("player_select") and beingCool:
		selected = false
		beingCool = false
		$CabinTimer.stop()
		$AnimationPlayer.stop()
		$AnimationPlayer.seek(0, true)
		get_parent().get_node("Clouds").visible = false
		get_parent().get_node("talkinghead").visible = false
		get_parent().get_node("BeingCool").stop()

func _on_CabinTimer_timeout():
	get_parent().coolness += 2
