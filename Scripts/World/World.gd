extends Node2D

# instances preload
const HOOL = preload("res://Scenes/Hoopers/HulaHooper.tscn")

# countdown/up variables
var deathsTotal = 0
var incidentsTotal = 0
var coolness = 100
var chaos = 0
var coolnessSubFactor = 1
export var spawnRate = 3

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
var smsUnanswered = 20

#get timer
onready var timer = get_node("GlobalTimer")

#AT START
func _ready():
#	randomize
	rng.randomize()
	
#	init timer
	timer.set_wait_time(1)
	timer.start()

#AT RUNTIME
func _physics_process(_delta):
	chaos = deathsTotal + incidentsTotal

#	UI changes
	get_node("Stats/Deaths").text = "Deaths : " + str(deathsTotal)
	get_node("Stats/Incidents").text = "Incidents : " + str(incidentsTotal)
	get_node("Stats/Coolness").text = "Coolness : " + str(coolness)
	get_node("Stats/Chaos").text = "Chaos : " + str(chaos)

#	spawn Hoopers
	if !spawnRate:
		var newHool = HOOL.instance()
		self.add_child(newHool)
		spawnRate = 3

#EVERY SECOND
func _on_GlobalTimer_timeout():
	color1 = rng.randf_range(0, 3)
	color2 = rng.randf_range(0, 3)
	color3 = rng.randf_range(0, 3)
	
	spawnRate -= 1
	
	if get_node("Staffcabin").beingCool == false:
		coolness -= coolnessSubFactor
	
#	if chaos limit reached
	if chaos >= 10 and !beingOnPhone:
		smsReceived = true
	
#	start countdown to getting fired
	if smsReceived:
		smsUnanswered -= 1
		
#	display you-got-fired message
	if smsUnanswered == 0:
		$UGOTFIRED.visible = true
	
#	display not-cool message
	if coolness <= 0:
		$NOTCOOL.visible = true
	
#	dancefloor change colors
	if (coolness % 2 == 0):
		$Backgrounds/Dancefloor/Dancefloor1.modulate = danceColors[color1]
		$Backgrounds/Dancefloor/Dancefloor2.modulate = danceColors[color2]
		$Backgrounds/Dancefloor/Dancefloor3.modulate = danceColors[color3]
