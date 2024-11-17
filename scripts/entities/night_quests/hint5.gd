extends Area3D

@onready var pickup_sound = $pickup_sound

func _ready():
	pass

func _physics_process(_delta):
	rotation.y += deg_to_rad(1)

func _on_body_entered(body):
	Global.hint5_collected = true
	body.in_hint = true
	pickup_sound.play()
	global_position.z -= 1000
	$"../Hint5Sheet".visible = true
	Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE)
	await get_tree().create_timer(0.8).timeout
	queue_free()
