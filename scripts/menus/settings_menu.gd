extends Control

@onready var mouse_sens_slider : HSlider = $mouse/mouse_sens_slider
@onready var mouse_sens : Label = $mouse/mouse_sens
@onready var film_grain = $film_grain/film_grain
@onready var button_white: Control = $film_grain/button_white
@onready var button_red: Control = $film_grain/button_red

# Settings titles
@onready var master_audio_label = $audio_settings/master_audio_label
@onready var music_audio_label = $audio_settings/music_audio_label
@onready var sfx_audio_label = $audio_settings/sfx_audio_label
@onready var menu_audio_label = $audio_settings/menu_audio_label

# Sliders
@onready var master_audio_slider = $audio_settings/master_audio_slider
@onready var music_audio_slider = $audio_settings/music_audio_slider
@onready var sfx_audio_slider = $audio_settings/sfx_audio_slider
@onready var menu_audio_slider = $audio_settings/menu_audio_slider

# Audio level labels
@onready var master_audio = $audio_settings/master_audio
@onready var music_audio = $audio_settings/music_audio
@onready var sfx_audio = $audio_settings/sfx_audio
@onready var menu_audio = $audio_settings/menu_audio

@onready var master_bus_index = AudioServer.get_bus_index("Master")
@onready var music_bus_index = AudioServer.get_bus_index("Music")
@onready var sfx_bus_index = AudioServer.get_bus_index("SFX")
@onready var menu_bus_index = AudioServer.get_bus_index("Menu")

@onready var back_button : Button = $back_button

@onready var button_sound: AudioStreamPlayer = $button_sound
@onready var fade = $fade_anim

func _ready():
	fade.play("fade_in")
	mouse_sens.text = str(round(Global.scale_mouse_sens_up(Global.mouse_sens)))
	master_audio.text = str(Global.master_audio)
	music_audio.text = str(Global.music_audio)
	sfx_audio.text = str(Global.sfx_audio)
	menu_audio.text = str(Global.menu_sounds_audio)
	
	mouse_sens_slider.value = round(Global.scale_mouse_sens_up(Global.mouse_sens))
	master_audio_slider.value = Global.master_audio * 100
	music_audio_slider.value = Global.music_audio * 100
	sfx_audio_slider.value = Global.sfx_audio * 100
	menu_audio_slider.value = Global.menu_sounds_audio * 100
	
	film_grain.button_pressed = Global.film_grain
	
	if Global.film_grain:
		button_white.visible = false
		button_red.visible = true
	else:
		button_white.visible = true
		button_red.visible = false
	

func _process(_delta):
	mouse_sens.text = str(round(Global.scale_mouse_sens_up(Global.mouse_sens)))
	master_audio.text = str(Global.master_audio * 100)
	music_audio.text = str(Global.music_audio * 100)
	sfx_audio.text = str(Global.sfx_audio * 100)
	menu_audio.text = str(Global.menu_sounds_audio * 100)

func _on_back_button_pressed():
	button_sound.play()
	await get_tree().create_timer(Global.menu_button_sound_timeout).timeout
	fade.play("fade_out")
	await get_tree().create_timer(1.0).timeout
	Global.switch_scene("res://scenes/menus/main_menu.tscn")

func _on_film_grain_pressed():
	Global.film_grain = !Global.film_grain
	Global.save_settings()
	
	if Global.film_grain:
		button_white.visible = false
		button_red.visible = true
	else:
		button_white.visible = true
		button_red.visible = false
		
	button_sound.play()
	await get_tree().create_timer(Global.menu_button_sound_timeout).timeout

func _on_master_audio_slider_value_changed(value):
	AudioServer.set_bus_volume_db(
		master_bus_index,
		linear_to_db(value / 40)
	)
	Global.master_audio = master_audio_slider.value / 100
	Global.save_settings()

func _on_music_audio_slider_value_changed(value):
	AudioServer.set_bus_volume_db(
		music_bus_index,
		linear_to_db(value / 40)
	)
	Global.music_audio = music_audio_slider.value / 100
	Global.save_settings()

func _on_sfx_audio_slider_value_changed(value):
	AudioServer.set_bus_volume_db(
		sfx_bus_index,
		linear_to_db(value / 40)
	)
	Global.sfx_audio = sfx_audio_slider.value / 100
	Global.save_settings()

func _on_menu_audio_slider_value_changed(value):
	AudioServer.set_bus_volume_db(
		menu_bus_index,
		linear_to_db(value / 40)
	)
	Global.menu_sounds_audio = menu_audio_slider.value / 100
	Global.save_settings()

func _on_mouse_sens_slider_value_changed(value):
	Global.mouse_sens = Global.scale_mouse_sens_down(mouse_sens_slider.value)
	Global.save_settings()
