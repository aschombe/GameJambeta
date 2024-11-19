extends Node3D

@onready var env = $env
@onready var grain = $Player/cam_fx/grain

@onready var player = $Player

@onready var portal = $portal
@onready var portal_mesh = $portal/MeshInstance3D
@onready var portal_timer = $portal/portal_timer
@onready var portal_color = $portal/portal_color
@onready var portal_sound = $portal/portal_sound
@onready var exploration_time = $exploration_time

const DAY = preload("res://scenes/skyboxes/day.tres")

func _ready():
	player.exploration_timer.visible = true
	Global.day = true
	portal_mesh.mesh.material.albedo_color = "ffff00"
	env.environment = DAY
	grain.visible = false
	exploration_time.start()
	Global.batteries_collected = 0
	
func _process(_delta):
	portal.rotation.y += deg_to_rad(1)

func _on_portal_body_entered(body):
	if body.collision_mask == 6:
		Global.in_portal = true
		portal_color.play("to_red")
		portal_timer.start()

func _on_portal_body_exited(body):
	if body.collision_mask == 6:
		Global.in_portal = false
		portal_color.stop()
		portal_sound.stop()
		portal_timer.stop()
		portal_mesh.mesh.material.albedo_color = "ffff00"

func _on_time_to_teleport_timeout():
	Global.day = false
	player.fade.play("fade_out")
	Global.flashlight_value = player.flashlight_meter.value
	await get_tree().create_timer(1).timeout
	Global.in_pause_menu = false
	Global.switch_scene("res://scenes/worlds/night.tscn")

func _on_exploration_time_timeout():
	player.force_teleport = true
	
