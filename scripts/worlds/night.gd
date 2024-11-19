extends Node3D

@onready var env = $env
@onready var grain = $Player/cam_fx/grain
@onready var player = $Player
@onready var portal = $portal

const NIGHT = preload("res://scenes/skyboxes/night.tres")

func _ready():
	Global.in_portal = false
	player.flashlight_meter.value = Global.flashlight_value
	env.environment = NIGHT

func _process(_delta):
	portal.rotation.y += deg_to_rad(1)
	if !Global.hint5_collected:
		portal.monitoring = false
		portal.visible = false
	else:
		portal.monitoring = true
		portal.visible = true

func _on_portal_body_entered(body):
	if body.name == "Player":
		player.win = true
		player.in_hint = true
		player.fade.play("fade_out")
		await get_tree().create_timer(1).timeout
		Global.switch_scene("res://scenes/worlds/end.tscn")
