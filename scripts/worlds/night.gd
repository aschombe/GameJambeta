extends Node3D

@onready var env = $env
@onready var grain = $Player/cam_fx/grain

const NIGHT = preload("res://scenes/skyboxes/night.tres")

# Called when the node enters the scene tree for the first time.
func _ready():
	env.environment = NIGHT
	grain.visible = false

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta):
	pass
