extends Area3D

@onready var pickup_sound = $pickup_sound

@onready var text_bubble = $"../../text_bubbles/TextBubble"
@onready var text_bubbles = $"../../text_bubbles"
@onready var hint_2 = $"../hint2"

func _ready():
	pass

func _physics_process(_delta):
	rotation.y += deg_to_rad(1)

func _on_body_entered(body):
	Global.hint1_collected = true
	body.in_hint = true
	pickup_sound.play()
	global_position.z -= 1000
	text_bubble.queue_free()
	text_bubbles.queue_free()
	$"../Hint1Sheet".visible = true
	Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE)
	await get_tree().create_timer(0.8).timeout
	hint_2.visible = true
	queue_free()
