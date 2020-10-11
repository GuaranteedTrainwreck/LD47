extends StaticBody2D

var staffhead1 = preload("res://Assets/BeingCool/kylehead.png")
var staffhead2 = preload("res://Assets/BeingCool/stevehead.png")
var staffhead3 = preload("res://Assets/BeingCool/emmahead.png")
var staffhead4 = preload("res://Assets/BeingCool/cathyhead.png")

var targeted = false
var beingCool = false
export var coolIncrement = 1

var rng = RandomNumberGenerator.new()

var currenttext = 1
var text0 = "[Wasted staff member]\n\nHey dude !\n\n I like your vibe, I'll come and help you with the infirmary !"
var text1 = "[Infirmary staff]\n\nWell this is boring.. I'm out !\n\nPeace !"
var text2 = "[Wasted staff member]\n\nWow look who's here !\n\nMaybe you're not as nerdy as you look !\n\nHave a beer with us !"
var text3 = "[Wasted staff member]\n\nCaRriE ?..\n\n CARRIIIIIE!!!! \n\n wait you're nooot Carrie !!!\n\n*burp*"
var text4 = "[Wasted staff member]\n\nHeeeeey maaaaan !\n\nCare for some sweeeeeet Red Babylon Indica ?\n\n *hhffffffff*"
var text5 = "[Wasted staff member]\n\nHey Charlie !\n\nCHARLIE\n\nCATCH ME CHARLIE I'M AIRBORNE !!!"
var text6 = "[Wasted staff member]\n\nHo hey new guy !\n\nHow's W O R K ?\n\nSucks doesn't it ?"
var text7 = "[Wasted staff member]\n\nYou know Rookie..\n\nI don't want to scare you but..\n\nI AM FUCKING HORNY BOIII !"
var textlist = [text2, text3, text4, text5, text6, text7]
var headlist = [staffhead1, staffhead2, staffhead3, staffhead4]

func _ready():
	rng.randomize()

func talkingHead(head, text):
	get_parent().get_node("TalkingHead/StaticBody2D").stafftalk = true
	get_parent().get_node("TalkingHead").visible = true
	get_parent().get_node("TalkingHead/talkinghead").set_texture(head)
	get_parent().get_node("TalkingHead/talktest").text = text
	get_parent().get_node("TalkingHead/banneranim").play("appear")

func powerUp(text):
	get_parent().get_node("bonus").text = text
	get_parent().get_node("bonus/AnimationPlayer").play("appear")
	get_parent().get_node("powerup").play()
	
func powerDown(text):
	get_parent().get_node("bonus").text = text
	get_parent().get_node("bonus/AnimationPlayer").play("appear")
	get_parent().get_node("powerdown").play()

func _on_banneranim_animation_finished(anim_name):
	get_parent().get_node("TalkingHead/StaticBody2D").stafftalk = false

func _physics_process(delta):
	beingCool = get_parent().beingCool
	
	if get_parent().coolness < 30 and get_parent().medicsMax > 1:
		powerDown("-1 heal..")
		talkingHead(staffhead3, text1)
		get_parent().medicsMax = 1
	if get_parent().coolness < 60 and get_parent().medicsMax > 2:
		powerDown("-1 heal..")
		talkingHead(staffhead2, text1)
		get_parent().medicsMax = 2
	if get_parent().coolness < 90 and get_parent().medicsMax > 3:
		powerDown("-1 heal..")
		talkingHead(staffhead4, text1)
		get_parent().medicsMax = 3
	if get_parent().coolness >= 30 and get_parent().medicsMax == 1:
		powerUp("+1 heal !")
		talkingHead(staffhead3, text0)	
		get_parent().medicsMax = 2
	if get_parent().coolness >= 60 and  get_parent().medicsMax == 2:
		powerUp("+1 heal !")
		talkingHead(staffhead2, text0)
		get_parent().medicsMax = 3
	if get_parent().coolness >= 90 and get_parent().medicsMax == 3:
		powerUp("+1 heal !")
		talkingHead(staffhead4, text0)
		get_parent().medicsMax = 4
			
	if Input.is_action_just_pressed("player_select") and !beingCool and !get_parent().beingOnPhone and targeted:
		$CabinTimer.set_wait_time(1)
		$CabinTimer.start()
		beingCool = true
		if get_parent().infirmaryClicked:
			get_parent().get_node("Infirmary").ClickInfirmary()
		$AnimationPlayer.play("selected")
		get_parent().get_node("BeingCool/Clouds").visible = true
		talkingHead(headlist[rng.randf_range(0, 3)], textlist[rng.randf_range(0, 5)])
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
	get_parent().coolness = clamp(get_parent().coolness + 2, 0, 100)
