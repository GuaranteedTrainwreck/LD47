extends StaticBody2D

#dancefloor limits
const XMIN = 32
const XMAX = 608
const YMIN = 224
const YMAX = 608

#get timer
onready var hoopTimer = get_node("HoopTimer")

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
#	init timer
	hoopTimer.set_wait_time(1)
	hoopTimer.start()
	
#	randomize
	rng.randomize()
	
#	init leaving countdown
	toleaving = rng.randf_range(5, 20)
	toleaving = int(toleaving)
	
#	init incident countdown
	toincident = rng.randf_range(5, 20)
	toincident = int(toincident)
	
#	fix spawn limits
	var x = rng.randf_range(XMIN, XMAX)
	x = int(x)
	var y = rng.randf_range(YMIN, YMAX)
	y = int(y)
	self.position.x = x
	self.position.y = y

#AT RUNTIME
func _physics_process(delta):
#	despawn at countdown's end
	if !toleaving:
		self.queue_free()
	
#	at incident
	if !toincident:
		incident = true
		self.rotation_degrees = 90
	
#	at death
	if !todeath:
		incident = false
		dead = true
		self.rotation_degrees = 180
		hoopTimer.stop()
		set_physics_process(false)
		get_parent().deaths += 1

#EVERY SECOND
func _on_Timer_timeout():
	if !incident and !dead:
		toleaving -= 1
		toincident -= 1
	elif !dead:
		todeath -= 1

#ON CLICK
func _on_HulaHooper_input_event(viewport, event, shape_idx):
#	check if infirmary is selected
	infirmarySelected = get_parent().get_node("Infirmary").selected
	
#	heal Hooper
	if event.is_action_pressed("player_action") and incident and infirmarySelected:
		self.rotation_degrees = 0
		toincident = rng.randf_range(5, 20)
		toincident = int(toincident)
		incident = false
		get_parent().get_node("Infirmary").selected = false
