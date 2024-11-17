extends CharacterBody3D

const SPEED = 5.0

@onready var animation_player = $AnimationPlayer

func _ready():
	animation_player.play("idle")

func _physics_process(delta):
	# Add the gravity.
	if not is_on_floor():
		velocity += get_gravity() * delta

	move_and_slide()
