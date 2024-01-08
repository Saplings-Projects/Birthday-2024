class_name AudioPreferences
extends Preferences


var fauna: float
var master: float
var music: float
var sfx: float

const _DEFAULT_FAUNA: float = 0.5
const _DEFAULT_MASTER: float = 1.0
const _DEFAULT_MUSIC: float = 0.5
const _DEFAULT_SFX: float = 0.5
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


func _apply_defaults():
	master = _DEFAULT_MASTER
	music = _DEFAULT_MUSIC
	sfx = _DEFAULT_SFX
	fauna = _DEFAULT_FAUNA


#endregion Preferences