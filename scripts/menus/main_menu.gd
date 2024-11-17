extends Control

@onready var button_sound: AudioStreamPlayer = $button_sound
@onready var fade = $fade_anim

func _ready():
	Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE)
	fade.play("fade_in")
	Global.load_settings()

func _on_start_button_pressed():
	button_sound.play()
	await get_tree().create_timer(Global.menu_button_sound_timeout).timeout
	fade.play("fade_out")
	await get_tree().create_timer(1.0).timeout
	Global.day = true
	Global.switch_scene("res://scenes/worlds/intro_scene.tscn")

func _on_quit_button_pressed():
	button_sound.play()
	await get_tree().create_timer(Global.menu_button_sound_timeout).timeout
	get_tree().quit()

func _on_settings_button_pressed():
	button_sound.play()
	await get_tree().create_timer(Global.menu_button_sound_timeout).timeout
	Global.switch_scene("res://scenes/menus/settings_menu.tscn")
