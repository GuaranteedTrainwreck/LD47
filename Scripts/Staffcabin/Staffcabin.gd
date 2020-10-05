extends StaticBody2D


var targeted = false
var beingCool = false
export var coolIncrement = 2

func _ready():
	pass

func _physics_process(delta):
	beingCool = get_parent().beingCool

	if Input.is_action_just_pressed("player_select") and !beingCool and !get_parent().beingOnPhone and targeted:
		$CabinTimer.set_wait_time(1)
		$CabinTimer.start()
		beingCool = true
		if get_parent().infirmaryClicked:
			get_parent().get_node("Infirmary").ClickInfirmary()
		$AnimationPlayer.play("selected")
		get_parent().get_node("BeingCool/Clouds").visible = true
		get_parent().get_node("TalkingHead").visible = true
		get_parent().get_node("BeingCool/BeingCoolAnim").play("smoke")
		$Rock.play(8)
		
	elif Input.is_action_just_pressed("player_select") and beingCool:
		beingCool = false
		$CabinTimer.stop()
		$AnimationPlayer.stop()
		$AnimationPlayer.seek(0, true)
		get_parent().get_node("BeingCool/Clouds").visible = false
		get_parent().get_node("TalkingHead").visible = false
		get_parent().get_node("BeingCool/BeingCoolAnim").stop()
		$Rock.stop()
	
	get_parent().beingCool = beingCool

func _on_Staffcabin_mouse_entered():
	targeted = true
func _on_Staffcabin_mouse_exited():
	targeted = false

func _on_CabinTimer_timeout():
	get_parent().coolness = clamp(get_parent().coolness + coolIncrement, 0.0, 100.0)
