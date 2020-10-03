extends Node2D

# instances preload
const HOOL = preload("res://Scenes/Hoopers/HulaHooper.tscn")

# countdown/up variables
var deathsTotal = 0
var incidentsTotal = 0
var coolness = 50
export var spawnRate = 3

#get timer
onready var timer = get_node("GlobalTimer")

#AT START
func _ready():
#	init timer
	timer.set_wait_time(1)
	timer.start()

#AT RUNTIME
func _physics_process(delta):
#	UI changes
	get_node("Deaths").text = "Deaths : " + str(deathsTotal)
	get_node("Incidents").text = "Incidents : " + str(incidentsTotal)
	get_node("Coolness").text = "Coolness : " + str(coolness)
	
#	spawn Hoopers
	if !spawnRate:
		var newHool = HOOL.instance()
		self.add_child(newHool)
		spawnRate = 3

#EVERY SECOND
func _on_GlobalTimer_timeout():
	coolness -= 1
	spawnRate -= 1

