extends Area3D

@onready var pickup_sound = $pickup_sound

func _ready():
	pass

func _physics_process(_delta):
	rotation.y += deg_to_rad(1)

func _on_body_entered(body):
	if body.flashlight_meter.value == 100:
		return
	if body.flashlight_meter.value == 0:
		body.flashlight_on = false
		
	body.flashlight_meter.value += 10
	Global.batteries_collected += 1
	global_position.z -= 1000
	pickup_sound.play()
	await get_tree().create_timer(0.5).timeout
	queue_free()
