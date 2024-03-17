class_name AudioPreferences
extends Preferences


var master: float
var music: float
var sfx: float
var fauna: float
var freq: float

const _DEFAULT_MASTER: float = 1.0
const _DEFAULT_MUSIC: float = 0.25
const _DEFAULT_SFX: float = 0.35
const _DEFAULT_FAUNA: float = 0.5
const _DEFAULT_FREQ: float = 100
const _SECTION_NAME: String = "audio"


#region Preferences

func _apply_config(config: ConfigFile):
	if not config.has_section(_SECTION_NAME):
		_apply_defaults()
		return
	
	master = config.get_value(_SECTION_NAME, "master", _DEFAULT_MASTER)
	music = config.get_value(_SECTION_NAME, "music", _DEFAULT_MUSIC)
	sfx = config.get_value(_SECTION_NAME, "sfx", _DEFAULT_SFX)
	fauna = config.get_value(_SECTION_NAME, "fauna", _DEFAULT_FAUNA)
	freq = config.get_value(_SECTION_NAME, "freq", _DEFAULT_FREQ)


func _apply_defaults():
	master = _DEFAULT_MASTER
	music = _DEFAULT_MUSIC
	sfx = _DEFAULT_SFX
	fauna = _DEFAULT_FAUNA
	freq = _DEFAULT_FREQ


func _save_config(config: ConfigFile):
	config.set_value(_SECTION_NAME, "master", master)
	config.set_value(_SECTION_NAME, "music", music)
	config.set_value(_SECTION_NAME, "sfx", sfx)
	config.set_value(_SECTION_NAME, "fauna", fauna)
	config.set_value(_SECTION_NAME, "freq", freq)


#endregion Preferences
