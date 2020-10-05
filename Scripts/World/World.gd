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

#booleans
var beingOnPhone = false
var beingCool = false
var healing = false
var smsReceived = false
var ambulanceReady = true
var ambulanceClicked = false

#endgame timers
var smsUnanswered = 20

#get timer
onready var timer = get_node("GlobalTimer")

#AT START
func _ready():
#	init timer
	timer.set_wait_time(1)
	timer.start()

#AT RUNTIME
func _physics_process(_delta):
	chaos = deathsTotal + incidentsTotal

#	UI changes
	get_node("Deaths").text = "Deaths : " + str(deathsTotal)
	get_node("Incidents").text = "Incidents : " + str(incidentsTotal)
	get_node("Coolness").text = "Coolness : " + str(coolness)
	get_node("Chaos").text = "Chaos : " + str(chaos)
	


#	spawn Hoopers
	if !spawnRate:
		var newHool = HOOL.instance()
		self.add_child(newHool)
		spawnRate = 3

#EVERY SECOND
func _on_GlobalTimer_timeout():
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
	
	
