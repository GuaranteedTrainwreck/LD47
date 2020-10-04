extends StaticBody2D


var targeted = false
var beingCool = false

func _ready():
	pass

func _physics_process(delta):
	beingCool = get_parent().beingCool

	if Input.is_action_just_pressed("player_select") and !beingCool and !get_parent().beingOnPhone and targeted:
		$CabinTimer.set_wait_time(1)
		$CabinTimer.start()
		beingCool = true
		if get_parent().healing:
			get_parent().get_node("Infirmary").ClickInfirmary()

		$AnimationPlayer.play("selected")
		get_parent().get_node("Clouds").visible = true
		get_parent().get_node("talkinghead").visible = true
		get_parent().get_node("BeingCool").play("smoke")
	elif Input.is_action_just_pressed("player_select") and beingCool:
		beingCool = false
		$CabinTimer.stop()
		$AnimationPlayer.stop()
		$AnimationPlayer.seek(0, true)
		get_parent().get_node("Clouds").visible = false
		get_parent().get_node("talkinghead").visible = false
		get_parent().get_node("BeingCool").stop()
	
	get_parent().beingCool = beingCool

func _on_Staffcabin_mouse_entered():
	targeted = true
func _on_Staffcabin_mouse_exited():
	targeted = false

func _on_CabinTimer_timeout():
	get_parent().coolness += 2
