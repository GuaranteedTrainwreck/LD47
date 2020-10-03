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
	
#	incident happens at countdown's end
	if !toincident:
		incident = true
		self.rotation_degrees = 90
	
#	death happens at countdown's end
	if !todeath:
		self.rotation_degrees = 180
		hoopTimer.stop()

#EVERY SECOND
func _on_Timer_timeout():
	if !incident and !dead:
		toleaving -= 1
		toincident -= 1
	elif !dead:
		todeath -= 1

#ON CLICK
func _on_HulaHooper_input_event(viewport, event, shape_idx):
	if event.is_action_pressed("player_action") and incident and !dead:
		self.rotation_degrees = 0
		toincident = rng.randf_range(5, 20)
		toincident = int(toincident)
		incident = false
		
