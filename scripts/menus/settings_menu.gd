extends Control

@onready var mouse_sens_slider : HSlider = $mouse/mouse_sens_slider
@onready var mouse_sens : Label = $mouse/mouse_sens
@onready var film_grain = $film_grain/film_grain
@onready var button_white: Control = $film_grain/button_white
@onready var button_red: Control = $film_grain/button_red

@onready var master_audio_label = $audio_settings/master_audio_label
#@onready var master_audio = $audio_settings/master_audio
@onready var master_audio_slider = $audio_settings/master_audio_slider
@onready var music_audio_label = $audio_settings/music_audio_label
#@onready var music_audio = $audio_settings/music_audio
@onready var music_audio_slider = $audio_settings/music_audio_slider
@onready var sfx_audio_label = $audio_settings/sfx_audio_label
#@onready var sfx_audio = $audio_settings/sfx_audio
@onready var sfx_audio_slider = $audio_settings/sfx_audio_slider
@onready var menu_audio_label = $audio_settings/menu_audio_label
#@onready var menu_audio = $audio_settings/menu_audio
@onready var menu_audio_slider = $audio_settings/menu_audio_slider

@onready var master_bus_index = AudioServer.get_bus_index("Master")
@onready var music_bus_index = AudioServer.get_bus_index("Music")
@onready var sfx_bus_index = AudioServer.get_bus_index("SFX")
@onready var menu_bus_index = AudioServer.get_bus_index("Menu")

@onready var back_button : Button = $back_button

@onready var button_sound: AudioStreamPlayer = $button_sound

# Called when the node enters the scene tree for the first time.
func _ready():
	Global.in_settings = true
	Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE)
	mouse_sens.text = str(roundi(1 + ((99/0.008) * (Global.mouse_sens - 0.001))))
	mouse_sens_slider.value = 1 + ((99/0.008) * (Global.mouse_sens - 0.001))
	film_grain.button_pressed = Global.film_grain
	
	if Global.film_grain:
		button_white.visible = false
		button_red.visible = true
	else:
		button_white.visible = true
		button_red.visible = false
	
	master_audio_slider.value = db_to_linear(Global.master_audio)
	music_audio_slider.value = db_to_linear(Global.music_audio)
	sfx_audio_slider.value = db_to_linear(Global.sfx_audio)
	menu_audio_slider.value = db_to_linear(Global.menu_sounds_audio)
	
	#master_audio.text = str(linear_to_db(Global.master_audio))
	#music_audio.text = str(linear_to_db(Global.music_audio))
	#sfx_audio.text = str(linear_to_db(Global.sfx_audio))
	#menu_audio.text = str(linear_to_db(Global.menu_sounds_audio))
	
# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta):
	pass

func _on_mouse_sens_slider_drag_ended(_value_changed):
	Global.mouse_sens = 0.001 + (0.008 * (mouse_sens_slider.value - 1))/99
	#$mouse_sens.text = str(roundi(1 + ((99/0.008) * (Global.mouse_sens - 0.001))))
	Global.save_settings()

func _on_back_button_pressed():
	button_sound.play()
	await get_tree().create_timer(Global.menu_button_sound_timeout).timeout
	if Global.in_game:
		Global.in_settings = false
		queue_free()
	else:
		Global.in_settings = false
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
		linear_to_db(value)
	)
	Global.save_settings()
	#master_audio.text = str(linear_to_db(Global.master_audio))

func _on_music_audio_slider_value_changed(value):
	AudioServer.set_bus_volume_db(
		music_bus_index,
		linear_to_db(value)
	)
	Global.save_settings()
	#music_audio.text = str(linear_to_db(Global.music_audio))

func _on_sfx_audio_slider_value_changed(value):
	AudioServer.set_bus_volume_db(
		sfx_bus_index,
		linear_to_db(value)
	)
	Global.save_settings()
	#sfx_audio.text = str(linear_to_db(Global.sfx_audio))

func _on_menu_audio_slider_value_changed(value):
	AudioServer.set_bus_volume_db(
		menu_bus_index,
		linear_to_db(value)
	)
	Global.save_settings()
	#menu_audio.text = str(linear_to_db(Global.menu_sounds_audio))
