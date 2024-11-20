extends Control

@onready var button_sound: AudioStreamPlayer = $button_sound
@onready var fade = $fade_anim
@onready var camera_movement = $camera_movement

func _ready():
	camera_movement.play("menu_cam_loop")
	Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE)
	fade.play("fade_in")
	Global.load_settings()

func _on_start_button_pressed():
	button_sound.play()
	await get_tree().create_timer(Global.menu_button_sound_timeout).timeout
	fade.play("fade_out")
	await get_tree().create_timer(1.0).timeout
	Global.day = true
	if Global.skip_cutscene:
		Global.switch_scene("res://scenes/worlds/day.tscn")
	else:
		Global.switch_scene("res://scenes/worlds/intro_scene.tscn")

func _on_quit_button_pressed():
	button_sound.play()
	await get_tree().create_timer(Global.menu_button_sound_timeout).timeout
	fade.play("fade_out")
	await get_tree().create_timer(1.0).timeout
	get_tree().quit()

func _on_settings_button_pressed():
	button_sound.play()
	await get_tree().create_timer(Global.menu_button_sound_timeout).timeout
	fade.play("fade_out")
	await get_tree().create_timer(1.0).timeout
	Global.switch_scene("res://scenes/menus/settings_menu.tscn")
