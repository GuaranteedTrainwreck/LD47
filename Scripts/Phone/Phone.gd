extends StaticBody2D


var smsReceived = false
var beingOnPhone = false
var typingDone = false
onready var pos = self.position
export var smsWaitingTime = 10

# Called when the node enters the scene tree for the first time.
func _ready():
	get_parent().smsUnanswered = smsWaitingTime

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _physics_process(delta):
	smsReceived = get_parent().smsReceived
	beingOnPhone = get_parent().beingOnPhone
	
	if smsReceived:
		$AnimatedSprite.play("sms")
	else:
		$AnimatedSprite.play("nosms")

func _on_Phone_input_event(_viewport, event, _shape_idx):
	if event.is_action_pressed("player_select") and smsReceived and !get_parent().beingCool:
		if get_parent().infirmaryClicked:
			get_parent().get_node("Infirmary").ClickInfirmary()
		position = Vector2(960, 590)
		get_parent().beingOnPhone = true
		get_parent().smsReceived = false
	elif event.is_action_pressed("player_select") and beingOnPhone:
		$Bip.play()
		var step : float = 1.0 / $Response.text.length()
		$Response.percent_visible += step
		if $Response.percent_visible >= 1:
			typingDone = true
		if typingDone:
			$Countdown.text = ""
			$Validate.play()
			$Response.percent_visible = 0
			$AnimatedSprite.play("nosms")
			position = pos
			typingDone = false
			get_parent().coolness -= 10
			get_parent().beingOnPhone = false
			get_parent().smsUnanswered = smsWaitingTime
			get_parent().ambuMax += 1
#			get_parent().chaos = 0
