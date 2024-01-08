class_name AudioPreferences
extends Preferences


var fauna: float
var master: float
var music: float
var sfx: float

const _default_fauna: float = 0.5
const _default_master: float = 1.0
const _default_music: float = 0.5
const _default_sfx: float = 0.5
const _section_name: String = "audio"


#region Preferences

func _apply_config(config: ConfigFile):
	if not config.has_section(_section_name):
		_apply_defaults()
		return
	
	master = config.get_value(_section_name, "master", _default_master)
	music = config.get_value(_section_name, "music", _default_music)
	sfx = config.get_value(_section_name, "sfx", _default_sfx)
	fauna = config.get_value(_section_name, "fauna", _default_fauna)


func _apply_defaults():
	master = _default_master
	music = _default_music
	sfx = _default_sfx
	fauna = _default_fauna


#endregion Preferences
