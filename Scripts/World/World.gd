extends Node2D

# instances preload
const HOOL = preload("res://Scenes/Hoopers/HulaHooper.tscn")

# countdown/up variables
var deathsTotal = 0
var incidentsTotal = 0
var coolness = 50
var chaos = 0
var coolnessSubFactor = 1
export var spawnRate = 3

#booleans
var onPhone = false

#get timer
onready var timer = get_node("GlobalTimer")

#AT START
func _ready():
#	init timer
	timer.set_wait_time(1)
	timer.start()

#AT RUNTIME
func _physics_process(delta):
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
	
#	boss calls
	if chaos > 5:
		onPhone = true
		$talkinghead.visible = true
		$talkinghead/talktest.text = "HEY ! VINCE TOLD ME THERE WAS SOME TROUBLE\nAT THE CLUB...\nEVERYTHING OK ?"
		coolnessSubFactor = 2
	
	
