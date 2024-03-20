class_name VideoController
extends Node2D


@export var resolutions: Array[ScreenResolution] = []

var _prefs: VideoPreferences


func enable_fullscreen():
	_prefs.window = VideoPreferences.WindowType.FULLSCREEN
	
	DisplayServer.window_set_flag(DisplayServer.WINDOW_FLAG_BORDERLESS, false)
	DisplayServer.window_set_mode(DisplayServer.WINDOW_MODE_FULLSCREEN)


func enable_windowed():
	_prefs.window = VideoPreferences.WindowType.WINDOWED
	
	DisplayServer.window_set_flag(DisplayServer.WINDOW_FLAG_BORDERLESS, false)
	DisplayServer.window_set_mode(DisplayServer.WINDOW_MODE_WINDOWED)
	
	_resize_window()


func enable_windowed_borderless():
	_prefs.window = VideoPreferences.WindowType.WINDOWED_BORDERLESS
	
	DisplayServer.window_set_flag(DisplayServer.WINDOW_FLAG_BORDERLESS, true)
	DisplayServer.window_set_mode(DisplayServer.WINDOW_MODE_MAXIMIZED)


func set_resolution(res_idx: int):
	if resolutions == null:
		printerr("Available resolution is null")
		return
	
	var len = resolutions.size()
	
	if res_idx < 0 or res_idx >= len:
		printerr("Out-of-range for resolutions (", res_idx, "; len=", len, ")")
		return
	
	var res = resolutions[res_idx]
	_prefs.width = res.width
	_prefs.height = res.height
	
	_resize_window()


func _apply_prefs():
	match _prefs.window:
		VideoPreferences.WindowType.FULLSCREEN:
			enable_fullscreen()
		VideoPreferences.WindowType.WINDOWED:
			enable_windowed()
		VideoPreferences.WindowType.WINDOWED_BORDERLESS:
			enable_windowed_borderless()
		_:
			printerr("Unknown window type for video preference: ", _prefs.window)


func _resize_window():
	if _prefs.window != VideoPreferences.WindowType.WINDOWED:
		return
	
	var width = _prefs.width;
	var height = _prefs.height;
	
	DisplayServer.window_set_size(Vector2i(width, height))
	# TODO: Change position of window for best fit in screen.

