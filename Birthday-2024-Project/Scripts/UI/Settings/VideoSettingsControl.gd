class_name VideoSettingsControl
extends Control


@export var resolution_options: OptionButton
var _height: int = 1080
var _width: int = 1920


# TODO: Most of the logic in this class ought to be moved to a class that is
#       dedicated to handling settings. (e.g. On game launch)

func on_screen_selected(index: int):
	match index:
		0:
			_enable_fullscreen()
		1:
			_enable_windowed()
		2:
			_enable_windowed_borderless()


func on_resolution_selected(index: int):
	match index:
		0:
			_resize_window(1920, 1080)
		1:
			_resize_window(1440, 900)
		2:
			_resize_window(1366, 768)


func _enable_fullscreen():
	resolution_options.disabled = true
	
	DisplayServer.window_set_mode(DisplayServer.WINDOW_MODE_EXCLUSIVE_FULLSCREEN)
	DisplayServer.window_set_flag(DisplayServer.WINDOW_FLAG_BORDERLESS, false)


func _enable_windowed():
	resolution_options.disabled = false
	
	DisplayServer.window_set_mode(DisplayServer.WINDOW_MODE_WINDOWED)
	DisplayServer.window_set_flag(DisplayServer.WINDOW_FLAG_BORDERLESS, false)
	
	_resize_window(_width, _height)


func _enable_windowed_borderless():
	resolution_options.disabled = true
	
	DisplayServer.window_set_mode(DisplayServer.WINDOW_MODE_MAXIMIZED)
	DisplayServer.window_set_flag(DisplayServer.WINDOW_FLAG_BORDERLESS, true)


func _resize_window(width: int, height: int):
	_width = width;
	_height = height;
	
	DisplayServer.window_set_size(Vector2i(width, height))
	# TODO: Change position of window for best fit in screen.


#region Node

func _ready():
	_enable_fullscreen()


#endregion Node
