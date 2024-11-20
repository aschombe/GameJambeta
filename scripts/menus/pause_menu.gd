extends ColorRect

@onready var animator = $AnimationPlayer
@onready var play_button = find_child("unpause_button")
@onready var open_note_button = find_child("open_note_button")
@onready var quit_button = find_child("quit_button")

const HINT_1_SHEET = "res://scenes/entities/night_quests/hint1_sheet.tscn"
const HINT_2_SHEET = "res://scenes/entities/night_quests/hint2_sheet.tscn"
const HINT_3_SHEET = "res://scenes/entities/night_quests/hint3_sheet.tscn"
const HINT_4_SHEET = "res://scenes/entities/night_quests/hint4_sheet.tscn"
const HINT_5_SHEET = "res://scenes/entities/night_quests/hint5_sheet.tscn"

func _ready():
	$".".position.x = -1500
	play_button.pressed.connect(unpause)
	open_note_button.pressed.connect(open_previous_note)
	quit_button.pressed.connect(quit_game)

func _unhandled_input(event):
	if event.is_action_pressed("escape") and !Global.in_pause_menu and !Global.in_portal:
		if $"../..".name == "Player":
			if !$"../..".in_hint:
				pause()
		else:
			pause()
	elif event.is_action_pressed("escape") and Global.in_pause_menu and !Global.viewing_previous_hint:
		unpause()
	
	if event.is_action_pressed("escape") and Global.in_pause_menu and Global.viewing_previous_hint:
		if Global.hint5_collected:
			Global.viewing_previous_hint = false
			if get_node_or_null("../../../hints/Hint5Sheet") != null:
				$"../../../hints/Hint5Sheet".queue_free()
		elif Global.hint4_collected:
			Global.viewing_previous_hint = false
			if get_node_or_null("../../../hints/Hint4Sheet") != null:
				$"../../../hints/Hint4Sheet".queue_free()
		elif Global.hint3_collected:
			Global.viewing_previous_hint = false
			if get_node_or_null("../../../hints/Hint3Sheet") != null:
				$"../../../hints/Hint3Sheet".queue_free()
		elif Global.hint2_collected:
			Global.viewing_previous_hint = false
			if get_node_or_null("../../../hints/Hint2Sheet") != null:
				$"../../../hints/Hint2Sheet".queue_free()
		elif Global.hint1_collected:
			Global.viewing_previous_hint = false
			if get_node_or_null("../../../hints/Hint1Sheet") != null:
				$"../../../hints/Hint1Sheet".queue_free()

func _process(delta: float) -> void:
	if !Global.day and !Global.in_pause_menu and !$"../..".in_hint:
		if Global.hint1_collected:
			if get_node_or_null("../../../hints/Hint1Sheet") != null:
				$"../../../hints/Hint1Sheet".queue_free()
		if Global.hint2_collected:
			if get_node_or_null("../../../hints/Hint2Sheet") != null:
				$"../../../hints/Hint2Sheet".queue_free()
		if Global.hint3_collected:
			if get_node_or_null("../../../hints/Hint3Sheet") != null:
				$"../../../hints/Hint3Sheet".queue_free()
		if Global.hint4_collected:
			if get_node_or_null("../../../hints/Hint4Sheet") != null:
				$"../../../hints/Hint4Sheet".queue_free()
		if Global.hint5_collected:
			if get_node_or_null("../../../hints/Hint5Sheet") != null:
				$"../../../hints/Hint5Sheet".queue_free()

func open_scene(file_path):
	var scene = load(file_path)
	if scene:
		var instance = scene.instantiate()
		call_deferred("spawn_child", instance)

func spawn_child(inst):
	$"../../../hints".add_child(inst)

func open_previous_note():
	if Global.viewing_previous_hint:
		return
	if !Global.in_pause_menu:
		return
	Global.viewing_previous_hint = true
	if Global.hint5_collected:
		open_scene(HINT_5_SHEET)
	elif Global.hint4_collected:
		open_scene(HINT_4_SHEET)
	elif Global.hint3_collected:
		open_scene(HINT_3_SHEET)
	elif Global.hint2_collected:
		open_scene(HINT_2_SHEET)
	elif Global.hint1_collected:
		open_scene(HINT_1_SHEET)
	else:
		Global.viewing_previous_hint = false
		$no_press.play()

func quit_game():
	if Global.viewing_previous_hint:
		return
	if !Global.in_pause_menu:
		return
	Global.in_pause_menu = false
	get_tree().paused = false
	Global.switch_scene("res://scenes/menus/main_menu.tscn")

func unpause():
	if Global.viewing_previous_hint:
		return
	if !Global.in_pause_menu:
		return
	get_tree().paused = false
	Global.in_pause_menu = false
	$".".position.x = -1500
	animator.play("unpause")
	Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)

func pause():
	Global.in_pause_menu = true
	$".".position.x = 0
	animator.play("pause")
	Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE)
	get_tree().paused = true
