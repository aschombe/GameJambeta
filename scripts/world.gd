extends Node3D

@onready var world_environment = $WorldEnvironment

var day_sky : PanoramaSkyMaterial
var night_sky : PanoramaSkyMaterial

func set_sky(new_material: PanoramaSkyMaterial):
	world_environment.environment.sky = new_material

# Called when the node enters the scene tree for the first time.
func _ready():
	var day_texture = load("res://assets/skyboxes/day.hdr")
	day_sky = PanoramaSkyMaterial.new()
	day_sky.panorama = day_texture
	
	var night_texture = load("res://assets/skyboxes/night.hdr")
	night_sky = PanoramaSkyMaterial.new()
	night_sky.panorama = night_texture
	
	set_sky(day_sky)

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta):
	pass
