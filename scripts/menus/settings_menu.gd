extends Control

@onready var mouse_sens_slider = $mouse_sens_slider
@onready var back_button = $back_button
@onready var film_grain : CheckButton = $film_grain

# Called when the node enters the scene tree for the first time.
func _ready():
	Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE)
	$mouse_sens.text = str(roundi(1 + ((99/0.008) * (Global.mouse_sens - 0.001))))
	mouse_sens_slider.value = 1 + ((99/0.008) * (Global.mouse_sens - 0.001))
	
# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta):
	pass

func _on_mouse_sens_slider_drag_ended(_value_changed):
	Global.mouse_sens = 0.001 + (0.008 * (mouse_sens_slider.value - 1))/99
	$mouse_sens.text = str(roundi(1 + ((99/0.008) * (Global.mouse_sens - 0.001))))
	Global.save_settings()

func _on_back_button_pressed():
	Global.switch_scene("res://scenes/menus/main_menu.tscn")

func _on_film_grain_pressed():
	Global.film_grain = !Global.film_grain
