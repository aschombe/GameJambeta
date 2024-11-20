extends Node3D

@onready var animation_player = $fade/AnimationPlayer
@onready var sound = $sound
@onready var die = $die
@onready var grain = $cam_fx/grain

func _ready():
	if Global.film_grain:
		grain.visible = true
	else:
		grain.visible = false

func _process(_delta):
	pass
	
func fade_out():
	animation_player.play("fade_out")

func reload_night():
	animation_player.play("fade_out")
	await get_tree().create_timer(2).timeout
	Global.switch_scene("res://scenes/worlds/night.tscn")
