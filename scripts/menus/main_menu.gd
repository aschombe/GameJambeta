extends Control

func _ready():
	Global.load_settings()

func _on_start_button_pressed():
	Global.switch_scene("res://scenes/world.tscn")

func _on_quit_button_pressed():
	get_tree().quit()

func _on_settings_button_pressed():
	Global.switch_scene("res://scenes/menus/settings_menu.tscn")
