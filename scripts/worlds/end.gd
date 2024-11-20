extends Node3D

@onready var explosion = $explosion
@onready var fade_anim = $fade_anim
@onready var driving_anim = $player_car/driving_anim

# Called when the node enters the scene tree for the first time.
func _ready():
	driving_anim.play("ending_cutscene")

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta):
	explosion.rotation.y += deg_to_rad(5)

func fade_in():
	fade_anim.play("fade_in")

func fade_out():
	fade_anim.play("fade_out")

func goto_score():
	Global.switch_scene("res://scenes/menus/score.tscn")
