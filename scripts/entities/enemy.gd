extends CharacterBody3D

const SPEED = 4.0

var player = null
var distance_to_player
@export var player_path : NodePath

@onready var nav_agent = $NavigationAgent3D
@onready var anim_tree = $AnimationTree

@onready var foot_steps = $foot_steps
@onready var growl = $growl
var can_growl = true

var stunned = false
@onready var stunned_timer = $"stunned-timer"
@onready var eye_light = $Skeleton3D/mesh_002/OmniLight3D
var play_stun = 1

func _ready():
	eye_light.light_color = Color(255, 0, 0)
	player = get_node(player_path)
	
func _process(_delta):
	distance_to_player = player.global_position.distance_to(global_position)
	velocity = Vector3.ZERO
	nav_agent.set_target_position(player.global_position)
	var next_nav_point = nav_agent.get_next_path_position()
	
	if !_target_in_range():
		player.racing_heart = false
	
	if _target_in_range() and not stunned and !player.in_hint and !player.win:
		if can_growl:
			player.racing_heart = true
			can_growl = false
			growl.play()
			
		velocity = (next_nav_point - global_position).normalized() * SPEED
		look_at(Vector3(player.global_position.x, global_position.y, player.global_position.z), Vector3.UP)	
		if !foot_steps.playing:
			foot_steps.play()
	else:
		#player.racing_heart = false
		foot_steps.stop()
	
	if stunned and play_stun:
		growl.stop()
		foot_steps.stop()
		if play_stun == 1:
			$"../death".play()
			play_stun = 0
		Global.score += 1
		eye_light.light_color = Color(255, 255, 0)
		stunned_timer.start()
		
	
	anim_tree.set("parameters/conditions/running", _target_in_range())
	anim_tree.set("parameters/conditions/idle", !_target_in_range() || stunned)
	
	if not is_on_floor():
		velocity += get_gravity()
	
	move_and_slide()
	
func _target_in_range():
	return global_position.distance_to(player.global_position) < 6

func _on_stunnedtimer_timeout():
	stunned = false
	eye_light.light_color = Color(255, 0, 0)
	play_stun = 1
