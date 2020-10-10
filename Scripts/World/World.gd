extends Node2D

#instances preload
const HOOL = preload("res://Scenes/Hoopers/HulaHooper.tscn")

#stats
var deathsTotal = 0
var incidentsTotal = 0
var coolness = 0
var chaos = 0
var timeElapsed = 0
var missedTexts = 0

#countdowns/ups
var smsUnanswered = 0
var spawnCountdown = 2

#variable settings
var chaosMax = 8
var coolnessMax = 100
var coolnessSubFactor = 1
var spawnRate = 2
var leavingRange = [8, 10]
var incidentRange = [4, leavingRange[1]]

#create random
var rng = RandomNumberGenerator.new()

#booleans
var gameover = false
var beingOnPhone = false
var beingCool = false
var infirmaryClicked = false
var smsReceived = false
var ambulanceReady = true
var ambulanceClicked = false

#infirmary variables
var onDuty = 0
var medicsMax = 1

#ambulance variables
var inAmbu = 0
var ambuMax = 1

#dancefloor things
var danceColors = ["a2ffcd", "ffffff", "4cafff"]
var color1 = 0
var color2 = 0
var color3 = 0

#get timer
onready var timer = get_node("GlobalTimer")

#AT START
func _ready():
#	randomize
	rng.randomize()
	
#	init timer
	timer.set_wait_time(1)

#AT RUNTIME
func _physics_process(_delta):
	
#	UI changes
	get_node("Stats/Deaths").text = "Deaths : " + str(deathsTotal)
	get_node("Stats/Incidents").text = "Choking : " + str(incidentsTotal)
	get_node("Stats/Coolness").text = "Coolness : " + str(coolness) + "/" + str(coolnessMax)
	get_node("Stats/Chaos").text = "Missed texts : " + str(missedTexts) + "/3"
	get_node("Stats/Time").text = "Time : " + str(timeElapsed)

#	spawn Hoopers
	if spawnCountdown <= 0:
		var newHool = HOOL.instance()
		self.add_child(newHool)
		spawnCountdown = spawnRate

#EVERY SECOND
func _on_GlobalTimer_timeout():
	
#	set dancefloor colors
	color1 = rng.randf_range(0, 3)
	color2 = rng.randf_range(0, 3)
	color3 = rng.randf_range(0, 3)
	
#	update stats / countdowns
	spawnCountdown -= 1
	timeElapsed += 1
	chaos = clamp(deathsTotal + incidentsTotal, 0, chaosMax)
	if get_node("Staffcabin").beingCool == false:
		coolness = clamp(coolness - coolnessSubFactor, 0, 100)
	
#	if chaos limit reached
	if deathsTotal >= 2 and !beingOnPhone and timeElapsed % 10 == 0:
		if !smsReceived:
			$Phone/Vibrate.play()	
			smsReceived = true
	
	if timeElapsed % 40 == 0:
		if !smsReceived:
			$Phone/Vibrate.play()	
			smsReceived = true
	
#	increase difficulty
	if timeElapsed % 60 == 0:
		leavingRange[0] += 5
		leavingRange[1] += 5
	
#	start countdown to getting fired
	if smsReceived:
		smsUnanswered -= 1
		get_node("Phone/Countdown").text = str(smsUnanswered)
		
#	if sms not answered
	if smsUnanswered <= 0 and !gameover:
		if ambuMax > 0:
			ambuMax -= 1
		missedTexts += 1
		smsReceived = false
		smsUnanswered = 10
		get_node("Phone/Countdown").text = ""
		if missedTexts >= 3:
			$UGOTFIRED.visible = true
			gameover = true
			$GlobalTimer.stop()
	
#	display not-cool message
#	if coolness <= 0 and !gameover:
#		$NOTCOOL.visible = true
#		gameover = true
#		$GlobalTimer.stop()
	
#	dancefloor change colors
	if timeElapsed % 2 == 0:
		$Backgrounds/Dancefloor/Dancefloor1.modulate = danceColors[color1]
		$Backgrounds/Dancefloor/Dancefloor2.modulate = danceColors[color2]
		$Backgrounds/Dancefloor/Dancefloor3.modulate = danceColors[color3]
