extends Node3D

@onready var env = $env
@onready var grain = $Player/cam_fx/grain
@onready var player = $Player
@onready var night_escape_timer = $Player/ui/night_escape_timer
@onready var portal = $portal
@onready var escape_time = $escape_time
var escape_timer_started = false

const NIGHT = preload("res://scenes/skyboxes/night.tres")

func _ready():
	player.flashlight_meter.value = Global.flashlight_value
	env.environment = NIGHT

func _process(_delta):
	portal.rotation.y += deg_to_rad(1)
	if !Global.hint5_collected and !escape_timer_started:
		portal.monitoring = false
		portal.visible = false
	else:
		if !escape_timer_started:
			escape_time.start()
			
		night_escape_timer.visible = true
		escape_timer_started = true
		portal.monitoring = true
		portal.visible = true

func _on_portal_body_entered(body):
	if body.name == "Player":
		player.win = true
		player.in_hint = true
		player.fade.play("fade_out")
		await get_tree().create_timer(1).timeout
		# cut away to win cutscene

func _on_night_escape_timer_timeout():
	print("You lose")
	# cut away to lose cutscene
