extends Area3D

@onready var pickup_sound = $pickup_sound

# Called when the node enters the scene tree for the first time.
func _ready():
	pass

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _physics_process(_delta):
	rotation.y += deg_to_rad(1)

func _on_body_entered(body):
	if body.flashlight_meter.value == 100:
		return
	body.flashlight_meter.value += 15
	global_position.z -= 1000
	pickup_sound.play()
	await get_tree().create_timer(0.5).timeout
	queue_free()
