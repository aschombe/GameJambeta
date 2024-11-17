extends Control

@onready var close_sound = $close_sound
@onready var player = $"../../Player"

func _ready():
	pass

func _process(delta):
	pass

func _on_close_button_pressed():
	position.x += 1000
	Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)
	player.in_hint = false
	close_sound.play()
	await get_tree().create_timer(0.8).timeout
	queue_free()
