extends Label3D

@onready var player = $"../../Player"
var distance_to_player : float

func _ready():
	pass

func _process(_delta):
	distance_to_player = player.global_position.distance_to(global_position)
	modulate.a = 1 - distance_to_player / 5
	outline_modulate.a = 1 - distance_to_player / 5
