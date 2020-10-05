extends StaticBody2D

#dancefloor limits
const XMIN = 448
const XMAX = 1464
const YMIN = 568
const YMAX = 1000

#create random
var rng = RandomNumberGenerator.new()

var characterId = 1
var characterName = "Hooper1"

#countdowns
export var leavingTimer : float = 10.0
export var incidentTimer : float = 10.0

#booleans
var suffocating = false
var dead = false
var infirmaryClicked = false
var ambulanceClicked = false

# AT START
func _ready():
#	randomize
	rng.randomize()
	
#	choose random character
	characterId = rng.randf_range(1, 5)
	characterId = int(characterId)
	characterName = "Hooper" + str(characterId)
	get_node(characterName).visible = true
	
#	init and start leaving countdown
	$LeavingTimer.set_wait_time(rng.randf_range(leavingTimer - 2, leavingTimer + 2))
	$LeavingTimer.start()
	
#	init and start suffocating countdown
	$IncidentTimer.set_wait_time(rng.randf_range(incidentTimer - 5, incidentTimer + 2))
	$IncidentTimer.start()

#	init death countdown
	$DeathTimer.set_wait_time(10)
	
	
#	fix spawn limits
	var x = rng.randf_range(XMIN, XMAX)
	x = int(x)
	var y = rng.randf_range(YMIN, YMAX)
	y = int(y)
	self.position.x = x
	self.position.y = y


#AT RUNTIME
func _physics_process(_delta):
	infirmaryClicked = get_parent().infirmaryClicked
	ambulanceClicked = get_parent().ambulanceClicked

#ON CLICK
func _on_HulaHooper_input_event(_viewport, event, _shape_idx):
#	heal Hooper
	if event.is_action_pressed("player_action") and suffocating and infirmaryClicked:
		$LeavingTimer.set_paused(false)
		$DeathTimer.stop()
		$IncidentTimer.set_wait_time(rng.randf_range(5, 20))
		$IncidentTimer.start()
		suffocating = false
		get_parent().infirmaryClicked = false
		get_parent().incidentsTotal -= 1
		get_parent().get_node("Infirmary/AnimatedSprite").get_material().set_shader_param("outline_width", 0)
		get_node(characterName).play("hooping")
		
#	pick up dead body
	if event.is_action_pressed("player_action") and dead and ambulanceClicked:
		self.queue_free()
		get_parent().deathsTotal -= 1
		get_parent().ambulanceReady = false
		get_parent().ambulanceClicked = false
		get_parent().get_node("Ambulance").get_node("Departure").play("departure")

#	DeathTimer Signal
func _on_DeathTimer_timeout():
	suffocating = false
	dead = true
	get_parent().incidentsTotal -= 1
	get_parent().deathsTotal += 1
	get_node(characterName).play("dead")

#	IncidentTimer Signal
func _on_IncidentTimer_timeout():
	$LeavingTimer.set_paused(true)
	suffocating = true
	get_parent().incidentsTotal += 1
	get_node(characterName).play("suffocating")
	$DeathTimer.start()

#	LeavingTimer Signal
func _on_LeavingTimer_timeout():
	self.queue_free()
