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
var chaosMax = 10
var coolnessMax = 100
var coolnessSubFactor = 1
var spawnRate = 3
var leavingRange = [10, 12]
var incidentRange = [5, leavingRange[1]]

#boss texting stuff
var SmsBoss1 = "Hey kid ! How are\nthings over there ?\nAnother day another\ndollar hey !?"
var SmsBoss2 = "Hey kid ! Kyle mixed up\nthe latest hoops order,\nso careful, they might\nbe a bit small.."
var SmsBoss3 = "Hey kid ! If that dick\nfrom Palms News calls,\ntell him to go fuck\nhimself. Cheers !"
var SmsBoss4 = "Hey kid ! Hope the staff\nis helping you a bit,\ninstead of jerking\neach other off.."
var SmsBoss5 = "Hey kid ! If the neighbor\ncomes sniffing\naround just turn\nthe electric fence on"
var SmsBoss6 = "Hey babe ! Excited about\ntonight ? I'm\ngetting horny by\nthe minute.."
var bossTexts = [SmsBoss1, SmsBoss2, SmsBoss3, SmsBoss4, SmsBoss5, SmsBoss6]
var answer1 = "Everything\nis ok !!"
var answer2 = "Ok that makes\nmore sense.."
var answer3 = "Will do !!"
var answer4 = "Yes, everyone\nis on duty !!"
var answer5 = "The electric\nwhat now ??"
var answer6 = "Hu..\nwrong number ??"
var answers = [answer1, answer2, answer3, answer4,answer5, answer6]

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
var talkingHeadEnded = false
var bossHelp = false

#infirmary variables
var onDuty = 1
var medicsMax = 1

#ambulance variables
var inAmbu = 1
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
	
	gameover = false



#AT RUNTIME
func _physics_process(_delta):
#	UI changes
	get_node("Stats/Deaths").text = str(inAmbu) + "/" + str(ambuMax)
	get_node("Stats/Incidents").text = str(onDuty) + "/" + str(medicsMax)
	get_node("Stats/Coolness").text = str(coolness) + "/" + str(coolnessMax)
	get_node("Stats/Chaos").text = str(missedTexts) + "/3"
	get_node("Stats/Time").text = "Time : " + str(timeElapsed)
	get_node("Stats/Warning").text = str(chaos) + "/" + str(chaosMax)	

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
	if get_node("Staffcabin").beingCool == false and timeElapsed % 3 == 0:
		coolness = clamp(coolness - coolnessSubFactor, 0, 100)
	
#	if chaos limit reached
	if deathsTotal >= 2 and !beingOnPhone and timeElapsed % 15 == 0:
		if !smsReceived:
			$Phone/Sms.text = "Hey kid ! Sounds like\nyou need a hand.\nHow about an extra\nspace in the ambulance ?!"
			$Phone/Response.text = "Great\nthanks boss !"
			$Phone/Vibrate.play()	
			smsReceived = true
			bossHelp = true
	
	if timeElapsed % 40 == 0 and !beingOnPhone:
		if !smsReceived:
			var rand = rng.randf_range(0, 6)
			$Phone/Sms.text = bossTexts[rand]
			$Phone/Response.text = answers[rand]
			$Phone/Vibrate.play()	
			smsReceived = true
			bossHelp = false
	
#	increase difficulty
	if timeElapsed % 60 == 0:
		leavingRange[0] += 4
		leavingRange[1] += 4
	if timeElapsed % 150 == 0 :
		spawnRate = 2
		
	
#	start countdown to getting fired
	if smsReceived:
		smsUnanswered -= 1
		get_node("Phone/Countdown").text = str(smsUnanswered)
		
#	if sms not answered
	if smsUnanswered <= 0 and !gameover:
		if ambuMax > 1:
			get_node("Staffcabin").powerDown("-1 ambulance space..")
			ambuMax -= 1
			inAmbu -= 1
		missedTexts += 1
		smsReceived = false
		smsUnanswered = 10
		get_node("Phone/Countdown").text = ""
		if missedTexts >= 3:
			$UGOTFIRED.visible = true
			$UGOTFIRED/endTime.text = "Time : " + str(timeElapsed)
			gameover = true
			$GlobalTimer.stop()
	
	if chaos >= chaosMax and !gameover:
		$NOTCOOL.visible = true
		gameover = true
		$GlobalTimer.stop()
	
#	dancefloor change colors
	if timeElapsed % 2 == 0:
		$Backgrounds/Dancefloor/Dancefloor1.modulate = danceColors[color1]
		$Backgrounds/Dancefloor/Dancefloor2.modulate = danceColors[color2]
		$Backgrounds/Dancefloor/Dancefloor3.modulate = danceColors[color3]


func _on_banneranim_animation_finished(anim_name):
	talkingHeadEnded = true
