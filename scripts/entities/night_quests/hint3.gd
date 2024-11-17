extends Area3D

@onready var pickup_sound = $pickup_sound
@onready var hint_4 = $"../hint4"

func _ready():
	pass

func _physics_process(_delta):
	rotation.y += deg_to_rad(1)

func _on_body_entered(body):
	Global.hint3_collected = true
	body.in_hint = true
	pickup_sound.play()
	global_position.z -= 1000
	$"../Hint3Sheet".visible = true
	Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE)
	await get_tree().create_timer(0.8).timeout
	hint_4.visible = true
	queue_free()
