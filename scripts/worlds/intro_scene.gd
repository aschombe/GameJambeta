extends Node3D

@onready var env = $env
const DAY = preload("res://scenes/skyboxes/day.tres")

@onready var anim = $player_car/driving_anim
@onready var fade_anim = $fade_anim

func _ready():
	Global.day = true
	Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)
	fade_anim.play("fade_in")
	anim.play("intro_cutscene")
	env.environment = DAY

func _process(_delta):
	pass

func fade_in():
	fade_anim.play("fade_in")

func fade_out():
	fade_anim.play("fade_out")

func goto_day():
	Global.switch_scene("res://scenes/worlds/day.tscn")
