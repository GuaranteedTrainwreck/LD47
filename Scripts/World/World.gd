extends Node2D

# instances preload
const HOOL = preload("res://Scenes/Hoopers/HulaHooper.tscn")

# countdown/up variables
var deaths = 0
var coolness = 50
var spawnrate = 3

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
	get_node("Deaths").text = "Deaths : " + str(deaths)
	get_node("Coolness").text = "Coolness : " + str(coolness)
	
#	spawn Hoopers
	if !spawnrate:
		var newHool = HOOL.instance()
		self.add_child(newHool)
		spawnrate = 3

#EVERY SECOND
func _on_GlobalTimer_timeout():
	coolness -= 1
	spawnrate -= 1
