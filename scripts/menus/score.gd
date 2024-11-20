extends Control

@onready var high_score = $high_score
@onready var score = $total_score/score
var display_score = 0

@onready var button_sound = $button_sound
@onready var fade = $fade_anim

func _ready():
	fade.play("fade_in")

func _process(delta):
	display_score = 1000 - (Global.score * 10) - Global.time_to_win
	if display_score > Global.high_score:
		Global.high_score = display_score
		Global.save_settings()
	high_score.text = str(Global.high_score)
	score.text = str(display_score)

func _on_back_button_pressed():
	button_sound.play()
	await get_tree().create_timer(Global.menu_button_sound_timeout).timeout
	fade.play("fade_out")
	await get_tree().create_timer(1.0).timeout
	Global.switch_scene("res://scenes/menus/main_menu.tscn")
