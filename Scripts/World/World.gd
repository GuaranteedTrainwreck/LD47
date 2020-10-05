extends Node2D

# instances preload
const HOOL = preload("res://Scenes/Hoopers/HulaHooper.tscn")

# countdown/up variables
var deathsTotal = 0
var incidentsTotal = 0
var coolness = 100
export var coolnessMax : int = 100
var chaos = 0
export var chaosMax : float = 50.0
var gameover = false
var timeElapsed = 0

export var coolnessSubFactor = 1
export var spawnInitialRatio : float = 3.0
var spawnRate = spawnInitialRatio
export var spawnDoubleTime : float = 20.0;
var spawnStep = 1.0 / spawnDoubleTime
var spawnRatio = 1.0

#create random
var rng = RandomNumberGenerator.new()

#booleans
var beingOnPhone = false
var beingCool = false
var infirmaryClicked = false
var smsReceived = false
var ambulanceReady = true
var ambulanceClicked = false

#dancefloor things
var danceColors = ["a2ffcd", "ffffff", "4cafff"]
var color1 = 0
var color2 = 0
var color3 = 0

#endgame timers
var smsUnanswered = 0

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
	get_node("Stats/Incidents").text = "Incidents : " + str(incidentsTotal)
	get_node("Stats/Coolness").text = "Coolness : " + str(coolness) + "/" + str(coolnessMax)
	get_node("Stats/Chaos").text = "Chaos : " + str(chaos) + "/" + str(chaosMax)
	get_node("Stats/Time").text = "Time : " + str(timeElapsed)

#	spawn Hoopers
	if spawnRate <= 0:
		var newHool = HOOL.instance()
		self.add_child(newHool)
		spawnRate = spawnInitialRatio / spawnRatio

#EVERY SECOND
func _on_GlobalTimer_timeout():
	timeElapsed += 1
	color1 = rng.randf_range(0, 3)
	color2 = rng.randf_range(0, 3)
	color3 = rng.randf_range(0, 3)
	spawnRatio += spawnStep
	spawnRate -= 1

	chaos = clamp(chaos + deathsTotal + incidentsTotal, 0.0, chaosMax)

	if get_node("Staffcabin").beingCool == false:
		coolness =clamp(coolness - coolnessSubFactor, 0.0, 100.0)
	
#	if chaos limit reached
	if chaos >= chaosMax and !beingOnPhone:
		smsReceived = true
	
#	start countdown to getting fired
	if smsReceived:
		smsUnanswered -= 1
		
#	display you-got-fired message
	if smsUnanswered <= 0 and !gameover:
		$UGOTFIRED.visible = true
		gameover = true
	
#	display not-cool message
	if coolness <= 0 and !gameover:
		$NOTCOOL.visible = true
		gameover = true
	
#	dancefloor change colors
	if timeElapsed % 2 == 0:
		$Backgrounds/Dancefloor/Dancefloor1.modulate = danceColors[color1]
		$Backgrounds/Dancefloor/Dancefloor2.modulate = danceColors[color2]
		$Backgrounds/Dancefloor/Dancefloor3.modulate = danceColors[color3]
