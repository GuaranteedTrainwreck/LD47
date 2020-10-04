extends StaticBody2D


var smsReceived = false
var beingOnPhone = false
var typingDone = false
onready var pos = self.position

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _physics_process(delta):
	smsReceived = get_parent().smsReceived
	beingOnPhone = get_parent().beingOnPhone

func _on_Phone_input_event(_viewport, event, _shape_idx):
	if event.is_action_pressed("player_select") and smsReceived and !get_parent().beingCool:
		if get_parent().healing:
			get_parent().get_node("Infirmary").ClickInfirmary()
		position = Vector2(960, 590)
		get_parent().beingOnPhone = true
		get_parent().smsReceived = false
	elif event.is_action_pressed("player_action") and beingOnPhone:
		var step : float = 1.0 / $Response.text.length()
		$Response.percent_visible += step
		if $Response.percent_visible >= 1:
			typingDone = true
	elif event.is_action_pressed("player_select") and typingDone:
		$Response.percent_visible = 0
		position = pos
		typingDone = false
		get_parent().beingOnPhone = false
