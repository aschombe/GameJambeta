extends Node

var current_scene = null
var mouse_sens = 0.00285
var master_audio = .5
var music_audio = .5
var sfx_audio = .5
var menu_sounds_audio = .5
var film_grain = true

var in_pause_menu = false
var viewing_previous_hint = false
var in_portal = false

var day : bool
var flashlight_value = 0
var batteries_collected = 0

var score

var menu_button_sound_timeout = 0.12

var hint1_collected = false
var hint2_collected = false
var hint3_collected = false
var hint4_collected = false
var hint5_collected = false

func scale_mouse_sens_up(x: float) -> float:
	var lower = 0.0009
	var upper = 0.009

	var log_lower = log(lower) / log(10)
	var log_upper = log(upper) / log(10)
	var log_x = log(x) / log(10)

	return ((log_x - log_lower) / (log_upper - log_lower)) * 100

func scale_mouse_sens_down(y: float) -> float:
	var lower = 0.0009
	var upper = 0.009

	var log_lower = log(lower) / log(10)
	var log_upper = log(upper) / log(10)
	
	var log_x = (y / 100) * (log_upper - log_lower) + log_lower
	return pow(10, log_x)

func save_settings():
	var save_dict = {
		"mouse_sens": mouse_sens,
		"film_grain": film_grain,
		"master_audio": master_audio,
		"music_audio": music_audio,
		"sfx_audio": sfx_audio,
		"menu_sounds_audio": menu_sounds_audio,
		"score": score,
	}
	
	var save_game = FileAccess.open("user://settings.save", FileAccess.WRITE)
	var json_string = JSON.stringify(save_dict)
	save_game.store_line(json_string)

func load_settings():
	if not FileAccess.file_exists("user://settings.save"):
		return

	var save_game = FileAccess.open("user://settings.save", FileAccess.READ)
	while save_game.get_position() < save_game.get_length():
		var json_string = save_game.get_line()
		var json = JSON.new()
		var parse_result = json.parse(json_string)
		if not parse_result == OK:
			print("JSON Parse Error: ", json.get_error_message()< " in ", json_string, " at line ", json.get_error_line())
		var settings = json.get_data()
		mouse_sens = settings.get("mouse_sens", mouse_sens)
		film_grain = settings.get("film_grain", film_grain)
		master_audio = settings.get("master_audio", master_audio)
		music_audio = settings.get("music_audio", music_audio)
		sfx_audio = settings.get("sfx_audio", sfx_audio)
		menu_sounds_audio = settings.get("menu_sounds_audio", menu_sounds_audio)
		score = settings.get("score", score)

func _ready():
	load_settings()
	var root = get_tree().root
	current_scene = root.get_child(root.get_child_count() - 1)
	score = 0

func switch_scene(res_path):
	call_deferred("_deferred_switch_scene", res_path)
	
func _deferred_switch_scene(res_path):
	current_scene.free()
	var s = load(res_path)
	current_scene = s.instantiate()
	get_tree().root.add_child(current_scene)
	get_tree().current_scene = current_scene
	
# For instantiating scenes
func open_scene(file_path):
	var scene = load(file_path)
	if scene:
		var instance = scene.instantiate()
		call_deferred("spawn_child", instance)

func spawn_child(inst):
	get_tree().get_root().add_child(inst)
