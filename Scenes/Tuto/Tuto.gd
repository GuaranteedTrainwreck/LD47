extends StaticBody2D

var currenttext = 1
var bosshead = preload("res://Assets/Tuto/bosshead.png")
var bosstext1 = "[BOSS]\n\nHey kid,\n\nwelcome to Hula Hoops Paradise !\n\nPeople come and go have a spin on the dancefloor, you look after them,\nhow hard can it be ?"
var bosstext2 = "The staff is a bunch of lazy morons,\n\nbut pay them a visit at the staff cabin and they just might\n\ngive you a hand with the infirmary !"
var bosstext3 = "The customers here are not the brightest kind,\n\nif you see one of them getting stuck, use the infirmary !\n\nIf things get a little.. messy there is an ambulance available.\n\nBut be careful, we only have one of those !"
var bosstext4 = "Well, I'm off for the day !\n\nI'll text you to see how things are going.\n\nYou'll be fine, just don't burn the place down haha ! (seriously, don't)\n\nBoss out !"
var textlist = [bosstext1, bosstext2, bosstext3, bosstext4]

func _ready():
	get_parent().get_node("TalkingHead").visible = true
	get_parent().get_node("TalkingHead/talkinghead").set_texture(bosshead)
	get_parent().get_node("TalkingHead/talktest").text = bosstext1
	get_parent().get_node("TalkingHead/banneranim").play("appear")


func _on_Tuto_input_event(_viewport, event, _shape_idx):
	if event.is_action_pressed("player_select"):
		if currenttext < 4:
			get_parent().get_node("TalkingHead/banneranim").stop()
			get_parent().get_node("TalkingHead/banneranim").seek(0.6)
			get_parent().get_node("TalkingHead/talktest").text = textlist[currenttext]
			get_parent().get_node("TalkingHead/banneranim").play("appear")
			currenttext += 1
		else:
			get_parent().get_node("TalkingHead").visible = false
			get_parent().get_node("TalkingHead/StaticBody2D").bosstalk = false
			get_parent().get_node("TalkingHead/StaticBody2D").visible = true			
			get_parent().get_node("TalkingHead/banneranim").stop()
			get_parent().timer.start()
			self.queue_free()
