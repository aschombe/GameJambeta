extends CharacterBody3D

const SPEED : float = 1.5
const JUMP_VELOCITY : float = 2.5

@onready var flashlight : SpotLight3D = $neck/Camera3D/arm/flashlight/SpotLight3D
var flashlight_on : bool = false
var flashlight_max : float = 100.0
@onready var flashlight_meter : ProgressBar = $ui/flashlight_meter
@onready var flashlight_sound : AudioStreamPlayer3D = $neck/Camera3D/arm/flashlight/flashlight_sound
var flash_on
var flash_off
@onready var light_cone = $neck/Camera3D/arm/flashlight/light_cone

@export_range(0.1, 3.0, 0.1, "or_greater") var look_sens: float = 1
@onready var neck : Node3D = $neck
@onready var camera : Camera3D = $neck/Camera3D
var init_neck_rot_x : float = 0
var init_neck_rot_z : float = 0

@onready var grain = $cam_fx/grain

func _ready():
	Global.in_game = true
	Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)
	init_neck_rot_x = neck.rotation.x
	init_neck_rot_z = neck.rotation.z
	
	flashlight.light_energy = 0
	flashlight_meter.get("theme_override_styles/fill").bg_color = "00ff00" # green
	flash_on = preload("res://assets/arm_flashlight/flashlight_on.ogg")
	flash_off = preload("res://assets/arm_flashlight/flashlight_off.ogg")
	flashlight_sound.stream = flash_on
	light_cone.monitoring = false
	
func _input(event: InputEvent) -> void:
	#if mouse_captured:
	if event is InputEventMouseMotion:
		$neck.rotate_y(-event.relative.x * Global.mouse_sens)
		camera.rotate_x(-event.relative.y * Global.mouse_sens)
		camera.rotation.x = clamp(camera.rotation.x, deg_to_rad(-80), deg_to_rad(80))

func _physics_process(delta):
	if Global.film_grain:
		grain.visible = true
	else:
		grain.visible = false
	
	# Add the gravity.
	if not is_on_floor():
		velocity += get_gravity() * delta
		
	if Input.is_action_just_pressed("left_click"):
		if !flashlight_on:
			flashlight_sound.stream = flash_on
			flashlight_sound.play()
		elif flashlight_on:
			flashlight_sound.stream = flash_off
			flashlight_sound.play()
			
		flashlight_on = !flashlight_on
		light_cone.monitoring = !light_cone.monitoring
	
		if !flashlight_on:
			flashlight.light_energy = 0
			$flashlight_timer.stop()
		elif flashlight_on and flashlight_meter.value > 0:
			flashlight_meter.value -= 1
			flashlight.light_energy = 1
			$flashlight_timer.start()
			
	if flashlight_meter.value == 0 and not $flashlight_timer.is_stopped():
		flashlight.light_energy = 0
		flashlight_sound.stream = flash_off
		flashlight_on = !flashlight_on
		flashlight_sound.play()
		$flashlight_timer.stop()
	
	if flashlight_meter.value <= 25:
		flashlight_meter.get("theme_override_styles/fill").bg_color = "ff0000" # red
	elif flashlight_meter.value <= 50:
		flashlight_meter.get("theme_override_styles/fill").bg_color = "ff6400" # orange
	elif flashlight_meter.value <= 75:
		flashlight_meter.get("theme_override_styles/fill").bg_color = "ffff00" # yellow
		
	if Input.is_action_just_pressed("jump") and is_on_floor():
		velocity.y = JUMP_VELOCITY

	var input_dir = Input.get_vector("left", "right", "forward", "backward")
	var direction = (neck.transform.basis * Vector3(input_dir.x, 0, input_dir.y)).normalized()
	if direction:
		velocity.x = direction.x * SPEED
		velocity.z = direction.z * SPEED
	else:
		velocity.x = move_toward(velocity.x, 0, SPEED)
		velocity.z = move_toward(velocity.z, 0, SPEED)

	move_and_slide()

func _on_flashlight_timer_timeout():
	flashlight_meter.value -= 1

func _on_light_cone_body_entered(body):
	if body.collision_mask == 5: # enemies are mask 5
		body.dead = true

func _on_hurt_field_body_entered(body):
	if body.collision_mask == 5 and !body.dead: # enemies are mask 5
		Global.switch_scene("res://scenes/worlds/day.tscn")
