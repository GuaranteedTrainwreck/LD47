extends StaticBody2D

#dancefloor limits
const XMIN = 448
const XMAX = 1464
const YMIN = 568
const YMAX = 1000

#create random
var rng = RandomNumberGenerator.new()

#new hooper ID
var characterId = 1
var characterName = "Hooper1"

#booleans
var suffocating = false
var dead = false

# AT START
func _ready():
#	randomize
	rng.randomize()
	
#	choose random character
	characterId = rng.randf_range(1, 5)
	characterId = int(characterId)
	characterName = "Hooper" + str(characterId)
	get_node(characterName).visible = true
	
#	init and start countdown to leaving
	$LeavingTimer.set_wait_time(rng.randf_range(get_parent().leavingRange[0], get_parent().leavingRange[1]))
	$LeavingTimer.start()
	
#	init and start countdown to choking
	$IncidentTimer.set_wait_time(rng.randf_range(get_parent().incidentRange[0], get_parent().incidentRange[1]))
	$IncidentTimer.start()

#	init countdown to death
	$DeathTimer.set_wait_time(8)
	
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

#ON LEFT CLICK
func _on_HulaHooper_input_event(_viewport, event, _shape_idx):
#	heal Hooper
	if event.is_action_pressed("player_select") and suffocating and get_parent().infirmaryClicked:
#		reset timers
		$LeavingTimer.set_paused(false)
		$DeathTimer.stop()
		$IncidentTimer.set_wait_time(rng.randf_range(get_parent().leavingRange[0], get_parent().leavingRange[1]))
		$IncidentTimer.start()
		
#		reset booleans
		suffocating = false
		
#		change global values
		get_parent().incidentsTotal -= 1
		get_parent().chaos -= 1
		get_parent().onDuty -= 1
		
#		reset animation
		get_node(characterName).play("hooping")
		
#		play sound
		$heal.play()
		
#		cancel click
		if get_parent().onDuty == 0 or get_parent().incidentsTotal == 0:
			Input.set_custom_mouse_cursor(null)
			get_parent().infirmaryClicked = false
			get_parent().get_node("Infirmary/AnimatedSprite").get_material().set_shader_param("outline_width", 0)
			get_parent().onDuty = get_parent().medicsMax
		
#	remove dead body
	if event.is_action_pressed("player_select") and dead and get_parent().ambulanceClicked:
	#	play sound
		get_parent().get_node("remove").play()
		
	#	remove entity
		self.queue_free()
		
#		change global values
		get_parent().get_node("Ambulance/AnimatedSprite").get_material().set_shader_param("outline_width", 0)
		get_parent().deathsTotal -= 1
		get_parent().inAmbu -= 1
		
#		cancel click / finish action
		if get_parent().inAmbu == 0 or get_parent().deathsTotal == 0:
			Input.set_custom_mouse_cursor(null)
			get_parent().ambulanceReady = false
			get_parent().ambulanceClicked = false
			get_parent().get_node("Ambulance").get_node("Departure").play("departure")
			get_parent().inAmbu = get_parent().ambuMax

#	death
func _on_DeathTimer_timeout():
	suffocating = false
	dead = true
	get_parent().incidentsTotal -= 1
	get_parent().deathsTotal += 1
	get_node(characterName).play("dead")

#	incident
func _on_IncidentTimer_timeout():
	$LeavingTimer.set_paused(true)
	suffocating = true
	get_parent().incidentsTotal += 1
	get_node(characterName).play("suffocating")
	$DeathTimer.start()

#	leaving
func _on_LeavingTimer_timeout():
	if suffocating:
		get_parent().incidentsTotal -= 1
		$LeavingTimer.stop()
		$LeavingTimer.set_wait_time(rng.randf_range(get_parent().leavingRange[0], get_parent().leavingRange[1]))
		$LeavingTimer.start()
	else:
		self.queue_free()
