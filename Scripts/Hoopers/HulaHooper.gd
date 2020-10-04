extends StaticBody2D

#dancefloor limits
const XMIN = 30
const XMAX = 1920
const YMIN = 608
const YMAX = 1080

#create random
var rng = RandomNumberGenerator.new()

#countdowns
var toleaving = 0
var toincident = 0
var todeath = 10

#booleans
var incident = false
var dead = false
var infirmarySelected = false

# AT START
func _ready():
#	randomize
	rng.randomize()
	
#	init and start leaving countdown
	$LeavingTimer.set_wait_time(rng.randf_range(5, 20))
	$LeavingTimer.start()
	
#	init and start incident countdown
	$IncidentTimer.set_wait_time(rng.randf_range(5, 20))
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
	pass

#ON CLICK
func _on_HulaHooper_input_event(_viewport, event, _shape_idx):
#	check if infirmary is selected
	infirmarySelected = get_parent().get_node("Infirmary").selected
	
#	heal Hooper
	if event.is_action_pressed("player_action") and incident and infirmarySelected:
		$LeavingTimer.set_paused(false)
		$DeathTimer.stop()
		$IncidentTimer.set_wait_time(rng.randf_range(5, 20))
		$IncidentTimer.start()
		self.rotation_degrees = 0
		incident = false
		get_parent().incidentsTotal -= 1
		get_parent().get_node("Infirmary").selected = false

#	DeathTimer Signal
func _on_DeathTimer_timeout():
	incident = false
	dead = true
	self.rotation_degrees = 180
	get_parent().incidentsTotal -= 1
	get_parent().deathsTotal += 1
	set_physics_process(false)

#	IncidentTimer Signal
func _on_IncidentTimer_timeout():
	$LeavingTimer.set_paused(true)
	incident = true
	get_parent().incidentsTotal += 1
	self.rotation_degrees = 90
	$DeathTimer.start()

#	LeavingTimer Signal
func _on_LeavingTimer_timeout():
	self.queue_free()
