extends CharacterBody3D

const SPEED = 4.0

var player = null
var distance_to_player

@onready var anim_tree = $AnimationTree

@export var player_path : NodePath

@onready var nav_agent = $NavigationAgent3D

@onready var foot_steps = $foot_steps
@onready var growl = $growl
var can_growl = true
@onready var death = $death
var dead = false

func _ready():
	player = get_node(player_path)
	
func _process(_delta):
	distance_to_player = player.global_position.distance_to(global_position)
	velocity = Vector3.ZERO
	nav_agent.set_target_position(player.global_position)
	var next_nav_point = nav_agent.get_next_path_position()
	
	if _target_in_range() and not dead:
		if can_growl:
			can_growl = false
			growl.play()
			
		velocity = (next_nav_point - global_position).normalized() * SPEED
		look_at(Vector3(player.global_position.x, global_position.y, player.global_position.z), Vector3.UP)	
		if !foot_steps.playing:
			foot_steps.play()
	else:
		foot_steps.stop()
	
	if dead:
		growl.stop()
		foot_steps.stop()
		$"../death".play()
		queue_free()
	
	anim_tree.set("parameters/conditions/running", _target_in_range())
	anim_tree.set("parameters/conditions/idle", !_target_in_range())
	
	if not is_on_floor():
		velocity += get_gravity()
	
	move_and_slide()
	
func _target_in_range():
	return global_position.distance_to(player.global_position) < 6
