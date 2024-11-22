extends CharacterBody3D

const SPEED : float = 1.5
const JUMP_VELOCITY : float = 2.5

@onready var flashlight : SpotLight3D = $neck/Camera3D/arm/flashlight/SpotLight3D
var flashlight_on : bool = false
var flashlight_max : float = 100.0
@onready var flashlight_meter : ProgressBar = $ui/flashlight_meter
@onready var flashlight_meter_cover = $ui/flashlight_meter_cover
@onready var flashlight_sound : AudioStreamPlayer = $neck/Camera3D/arm/flashlight/flashlight_sound
var flash_on
var flash_off
@onready var light_cone = $neck/Camera3D/arm/flashlight/light_cone

@export_range(0.1, 3.0, 0.1, "or_greater") var look_sens: float = 1
@onready var neck : Node3D = $neck
@onready var camera : Camera3D = $neck/Camera3D

@onready var grain = $cam_fx/grain
@onready var fade = $fade/AnimationPlayer
@onready var scream = $fade/scream
var dead : bool = false

@onready var map = $ui/map_background/map
@onready var map_background = $ui/map_background

@onready var heartbeat = $heartbeat

@onready var exploration_timer = $ui/exploration_timer
var force_teleport : bool = false

var in_hint = false
var win = false

var cheat1_marker : Marker3D
var cheat2_marker : Marker3D
var cheat3_marker : Marker3D
var cheat4_marker : Marker3D
var cheat5_marker : Marker3D

func _ready():
	Global.in_map = false
	map.visible = false
	map_background.visible = false
	
	if Global.day:
		exploration_timer.visible = true
		heartbeat.volume_db = -80
	else:
		cheat1_marker = $"../cheats/note1"
		cheat2_marker = $"../cheats/note2"
		cheat3_marker = $"../cheats/note3"
		cheat4_marker = $"../cheats/note4"
		cheat5_marker = $"../cheats/note5"
		exploration_timer.visible = false
		heartbeat.volume_db = -20

	if Global.film_grain and !Global.day:
		grain.visible = true
	else:
		grain.visible = false
	
	Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)
	
	flashlight.light_energy = 0
	flashlight_meter.value = 0.0
	flashlight_meter.get("theme_override_styles/fill").bg_color = "00ff00" # green
	flash_on = preload("res://assets/arm_flashlight/flashlight_on.ogg")
	flash_off = preload("res://assets/arm_flashlight/flashlight_off.ogg")
	flashlight_sound.stream = flash_on
	light_cone.monitoring = false
		
	fade.play("fade_in")
	
func _input(event: InputEvent) -> void:
	if event is InputEventMouseMotion and !dead and !in_hint and !win and !Global.in_map:
		$neck.rotation.y += (-event.relative.x * Global.mouse_sens)
		camera.rotation.x += (-event.relative.y * Global.mouse_sens)
		camera.rotation.x = clamp(camera.rotation.x, deg_to_rad(-80), deg_to_rad(80))

func _physics_process(delta):
	if Global.day:
		var minutes = floor($"..".exploration_time.time_left / 60.0)
		var seconds = floor(fmod($"..".exploration_time.time_left, 60.0))
		if seconds < 10:
			exploration_timer.text = "Time Until Night: " + str(minutes) + ":0" + str(seconds)
		else:
			exploration_timer.text = "Time Until Night: " + str(minutes) + ":" + str(seconds)
		
		if force_teleport:
			position = Vector3(0, .8, -19)
			return
	else:
		if !flashlight_on:
			flashlight_meter_cover.visible = true
			flashlight_meter.visible = false
		else:
			flashlight_meter_cover.visible = false
			flashlight_meter.visible = true
	
	if not is_on_floor():
		velocity += get_gravity() * delta
		
	if Input.is_action_just_pressed("map"):
		if !Global.in_pause_menu:
			Global.in_map = !Global.in_map
			map.visible = !map.visible
			map_background.visible = !map_background.visible
	
	# CHEATS
	# ===================================================
	if Input.is_action_just_pressed("flashlight_cheat"):
		flashlight_meter.value = 100.0
		
	if Input.is_action_just_pressed("tp1"):
		global_position = cheat1_marker.global_position
	elif Input.is_action_just_pressed("tp2"):
		global_position = cheat2_marker.global_position
	elif Input.is_action_just_pressed("tp3"):
		global_position = cheat3_marker.global_position
	elif Input.is_action_just_pressed("tp4"):
		global_position = cheat4_marker.global_position
	elif Input.is_action_just_pressed("tp5"):
		global_position = cheat5_marker.global_position
	#====================================================
	
	if Input.is_action_just_pressed("left_click") and !dead and !in_hint and !win and !Global.in_map:
		if !flashlight_on:
			flashlight_sound.stream = flash_on
			flashlight_sound.play()
		elif flashlight_on:
			flashlight_sound.stream = flash_off
			flashlight_sound.play()
			
		if flashlight_meter.value > 0:
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
	else:
		flashlight_meter.get("theme_override_styles/fill").bg_color = "00ff00" # green
		
	if Input.is_action_just_pressed("jump") and is_on_floor() and !dead and !in_hint and !win and !Global.in_map:
		velocity.y = JUMP_VELOCITY

	var input_dir = Input.get_vector("left", "right", "forward", "backward")
	var direction = (neck.transform.basis * Vector3(input_dir.x, 0, input_dir.y)).normalized()
	if direction and !dead and !in_hint and !Global.in_map:
		velocity.x = direction.x * SPEED
		velocity.z = direction.z * SPEED
	else:
		velocity.x = move_toward(velocity.x, 0, SPEED)
		velocity.z = move_toward(velocity.z, 0, SPEED)

	move_and_slide()

func _on_flashlight_timer_timeout():
	if !in_hint and !win and !dead:
		flashlight_meter.value -= 1

func _on_light_cone_body_entered(body):
	if body.collision_mask == 5 and flashlight_meter.value != 0:
		body.stunned = true
		body.stunned_timer.stop()

func _on_light_cone_body_exited(body):
	if body.collision_mask == 5:
		body.stunned_timer.start()

func _on_hurt_field_body_entered(body):
	if body.collision_mask == 5 and !body.stunned and !dead and !win: # enemies are mask 5
		dead = true
		Global.switch_scene("res://scenes/worlds/die.tscn")
		#scream.play()
		#fade.play("fade_out")
		#await get_tree().create_timer(2).timeout
		#Global.switch_scene("res://scenes/worlds/night.tscn")
