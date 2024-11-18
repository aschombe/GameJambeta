extends Control

@onready var close_sound = $close_sound
@onready var player = $"../../Player"
@onready var close_button = $ColorRect/close_button

func _ready():
	if Global.in_pause_menu:
		close_button.text = "Press ESCAPE to close"
		close_button.disabled = true
	else:
		close_button.text = "Close"
		close_button.disabled = false

func _process(_delta):
	pass

func _on_close_button_pressed():
	if !Global.in_pause_menu:
		position.x += 1000
		Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)
		player.in_hint = false
		close_sound.play()
		await get_tree().create_timer(0.8).timeout
		queue_free()
