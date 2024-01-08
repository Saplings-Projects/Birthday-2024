class_name VideoSettingsControl
extends Control


@export var window_options: OptionButton
@export var resolution_options: OptionButton

var _gm: GameMaster

const _CUSTOM_OPTION_ID: int = 999
const _RESOLUTION_FORMAT: String = "%dx%d"


func revert_changes():
	var video = _gm.user_prefs.video
	
	# Handle window options
	if video.window < window_options.item_count:
		window_options.select(video.window)
		resolution_options.disabled = video.window != VideoPreferences.WindowType.WINDOWED
	else:
		resolution_options.disabled = true
		_add_and_select_custom(window_options)
	
	# Handle resolution options
	var resolutions = _gm.video_controller.resolutions
	var using_preset = false # Assume not using an available resolution
	var i = 0
	
	while not using_preset and i < resolutions.size():
		var res = resolutions[i]
		i = i + 1
		
		if res.width != video.width or res.height != video.height:
			continue
		
		using_preset = true
		resolution_options.select(i - 1)
	
	if not using_preset:
		_add_and_select_custom(resolution_options)


func _add_and_select_custom(options: OptionButton):
	options.add_item("Custom", _CUSTOM_OPTION_ID)
	
	var idx = options.get_item_index(_CUSTOM_OPTION_ID)
	options.selected = idx
	options.set_item_disabled(idx, true)


func _on_resolution_selected(index: int):
	_gm.video_controller.set_resolution(index)
	_remove_custom(resolution_options)


func _on_window_selected(index: int):
	match index:
		VideoPreferences.WindowType.FULLSCREEN:
			resolution_options.disabled = true
			_gm.video_controller.enable_fullscreen()
		VideoPreferences.WindowType.WINDOWED:
			resolution_options.disabled = false
			_gm.video_controller.enable_windowed()
		VideoPreferences.WindowType.WINDOWED_BORDERLESS:
			resolution_options.disabled = true
			_gm.video_controller.enable_windowed_borderless()
		_:
			printerr("Unhandled screen type selected")
	
	_remove_custom(window_options)


func _remove_custom(options: OptionButton):
	var idx = options.get_item_index(_CUSTOM_OPTION_ID)
	
	if idx >= 0:
		options.remove_item(idx)


#region Node

func _ready():
	_gm = get_node("/root/GlobalGameMaster")
	
	# Setup resolution options
	var resolutions = _gm.video_controller.resolutions
	
	for i in range(resolutions.size()):
		var res = resolutions[i]
		
		resolution_options.add_item(_RESOLUTION_FORMAT % [res.width, res.height], i)
	
	revert_changes()
	
	# Connect listeners
	window_options.item_selected.connect(_on_window_selected)
	resolution_options.item_selected.connect(_on_resolution_selected)


#endregion Node
