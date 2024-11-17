extends ColorRect

@onready var animator = $AnimationPlayer
@onready var play_button = find_child("unpause_button")
@onready var settings_button = find_child("settings_button")
@onready var quit_button = find_child("quit_button")

func _ready():
	$".".position.x -= 1000
	play_button.pressed.connect(unpause)
	settings_button.pressed.connect(open_settings)
	quit_button.pressed.connect(quit_game)

func _unhandled_input(event):
	if event.is_action_pressed("escape") and not Global.in_pause_menu:
		pause()
	elif event.is_action_pressed("escape") and Global.in_pause_menu:
		unpause()
	
func open_settings():
	Global.open_scene("res://scenes/menus/settings_menu.tscn")

func quit_game():
	Global.in_pause_menu = false
	get_tree().paused = false
	Global.switch_scene("res://scenes/menus/main_menu.tscn")

func unpause():
	$".".position.x -= 1000
	animator.play("unpause")
	get_tree().paused = false
	Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)
	Global.in_pause_menu = false

func pause():
	Global.in_pause_menu = true
	$".".position.x += 1000
	animator.play("pause")
	get_tree().paused = true
	Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE)
