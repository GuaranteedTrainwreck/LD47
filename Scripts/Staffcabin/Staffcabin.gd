extends StaticBody2D

var staffhead = preload("res://Assets/BeingCool/kylehead.png")
var targeted = false
var beingCool = false
export var coolIncrement = 2

var currenttext = 1
var text0 = "[Wasted staff member]\n\nHey dude !\n\n I like your vibe, I'll come and give you a hand at the infirmary\n\nfor a while !"
var text1 = "[Infirmary staff]\n\nWell this is boring.. I'm out !\n\nPeace !"
var text2 = "[Wasted staff member]\n\nWow look who's here !\n\nMaybe you're not as nerdy as you look !\n\nHave a beer with us !"
var textlist = [text0, text1]

func _ready():
	pass

func talkingHead(head, text):
	get_parent().get_node("TalkingHead/StaticBody2D").stafftalk = true
	get_parent().get_node("TalkingHead").visible = true
	get_parent().get_node("TalkingHead/talkinghead").set_texture(staffhead)
	get_parent().get_node("TalkingHead/talktest").text = text
	get_parent().get_node("TalkingHead/banneranim").play("appear")

func _on_banneranim_animation_finished(anim_name):
	get_parent().get_node("TalkingHead/StaticBody2D").stafftalk = false

func _physics_process(delta):
	beingCool = get_parent().beingCool
	
	if get_parent().coolness < 30 and get_parent().medicsMax > 1:
		talkingHead(staffhead, text1)
		get_parent().medicsMax = 1
	if get_parent().coolness < 60 and get_parent().medicsMax > 2:
		talkingHead(staffhead, text1)
		get_parent().medicsMax = 2
	if get_parent().coolness < 90 and get_parent().medicsMax > 3:
		talkingHead(staffhead, text1)
		get_parent().medicsMax = 3
	if get_parent().coolness >= 30 and get_parent().medicsMax == 1:
		talkingHead(staffhead, text0)	
		get_parent().medicsMax = 2
	if get_parent().coolness >= 60 and  get_parent().medicsMax == 2:
		talkingHead(staffhead, text0)
		get_parent().medicsMax = 3
	if get_parent().coolness >= 90 and get_parent().medicsMax == 3:
		talkingHead(staffhead, text0)
		get_parent().medicsMax = 4
			
	if Input.is_action_just_pressed("player_select") and !beingCool and !get_parent().beingOnPhone and targeted:
		$CabinTimer.set_wait_time(1)
		$CabinTimer.start()
		beingCool = true
		if get_parent().infirmaryClicked:
			get_parent().get_node("Infirmary").ClickInfirmary()
		$AnimationPlayer.play("selected")
		get_parent().get_node("BeingCool/Clouds").visible = true
		talkingHead(staffhead, text2)
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
		get_parent().get_node("TalkingHead/banneranim").stop()
		$Rock.stop()
	
	get_parent().beingCool = beingCool

func _on_Staffcabin_mouse_entered():
	targeted = true
func _on_Staffcabin_mouse_exited():
	targeted = false

func _on_CabinTimer_timeout():
	get_parent().coolness = clamp(get_parent().coolness + coolIncrement, 0, 100)
