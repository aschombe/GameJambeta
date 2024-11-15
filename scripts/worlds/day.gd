extends Node3D

@onready var env = $env

const DAY = preload("res://scenes/skyboxes/day.tres")
const NIGHT = preload("res://scenes/skyboxes/night.tres")

# Called when the node enters the scene tree for the first time.
func _ready():
	env.environment = NIGHT

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta):
	pass
