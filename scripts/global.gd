extends Node

var current_scene = null
var mouse_sens = 0.0015
var master_audio = 1
var music_audio = 1
var sfx_audio = 1
var menu_sounds_audio = 1
var film_grain = true

func _ready():
	var root = get_tree().root
	current_scene = root.get_child(root.get_child_count() - 1)

func save_settings():
	var save_dict = {
		"mouse_sens": mouse_sens,
		"film_grain": film_grain,
		"master_audio": master_audio,
		"music_audio": music_audio,
		"sfx_audio": sfx_audio,
		"menu_sounds_audio": menu_sounds_audio,
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

func switch_scene(res_path):
	call_deferred("_deferred_switch_scene", res_path)
	
func _deferred_switch_scene(res_path):
	current_scene.free()
	var s = load(res_path)
	current_scene = s.instantiate()
	get_tree().root.add_child(current_scene)
	get_tree().current_scene = current_scene
