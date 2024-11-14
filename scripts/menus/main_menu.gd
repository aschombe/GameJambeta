extends Control

@onready var button_sound: AudioStreamPlayer = $button_sound

func _ready():
	Global.load_settings()

func _on_start_button_pressed():
	button_sound.play()
	await get_tree().create_timer(Global.button_sound_timeout).timeout
	Global.switch_scene("res://scenes/world.tscn")

func _on_quit_button_pressed():
	button_sound.play()
	await get_tree().create_timer(Global.button_sound_timeout).timeout
	get_tree().quit()

func _on_settings_button_pressed():
	button_sound.play()
	await get_tree().create_timer(Global.button_sound_timeout).timeout
	Global.switch_scene("res://scenes/menus/settings_menu.tscn")
