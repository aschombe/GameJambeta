extends Node3D

func _ready():
	pass

func _process(_delta):
	if Input.is_action_just_pressed("left_click"):
		take_screenshot()

func take_screenshot():
	await RenderingServer.frame_post_draw
	var sshot = get_viewport().get_texture().get_image()
	sshot.save_png("user://icon.png")
