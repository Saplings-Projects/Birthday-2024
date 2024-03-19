class_name VideoPreferences
extends Preferences


var height: int
var width: int
var window: WindowType

const _DEFAULT_HEIGHT: int = 900
const _DEFAULT_WIDTH: int = 1600
const _DEFAULT_WINDOW: WindowType = WindowType.WINDOWED
const _SECTION_NAME: String = "video"


#region Preferences

func _apply_config(config: ConfigFile):
	if not config.has_section(_SECTION_NAME):
		_apply_defaults()
		return
	
	width = config.get_value(_SECTION_NAME, "width", _DEFAULT_WIDTH)
	height = config.get_value(_SECTION_NAME, "height", _DEFAULT_HEIGHT)
	window = config.get_value(_SECTION_NAME, "window", _DEFAULT_WINDOW)


func _apply_defaults():
	width = _DEFAULT_WIDTH
	height = _DEFAULT_HEIGHT
	window = _DEFAULT_WINDOW


func _save_config(config: ConfigFile):
	config.set_value(_SECTION_NAME, "width", width)
	config.set_value(_SECTION_NAME, "height", height)
	config.set_value(_SECTION_NAME, "window", window)


#endregion Preferences

enum WindowType
{
	FULLSCREEN = 0,
	WINDOWED = 1,
	WINDOWED_BORDERLESS = 2,
}

