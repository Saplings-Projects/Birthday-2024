class_name PuzzleUiManager
extends CanvasLayer

@export var controller: GameManager

@export_group("Screens")
@export var main_screen: PuzzleMainScreen
@export var settings_window: SettingsWindow

@export_group("States")
@export var play_state: PuzzleUiPlayState
@export var win_state: PuzzleUiWinState

var _current_state: PuzzleUiState


func hide_settings_window():
	settings_window.hide()


func on_puzzle_initialized():
	pass


func on_puzzle_state_changed(state: GameState):
	if state is GamePlayState:
		_switch_state(play_state)
	elif state is GameWinState:
		_switch_state(win_state)
	else:
		printerr("Unhandled puzzle state in puzzle UI Manager", self)


func show_main_screen():
	_disable_all_screens()
	main_screen.show()


func show_settings_window():
	settings_window.show()


func _disable_all_screens():
	main_screen.hide()
	settings_window.hide()


func _switch_state(state: PuzzleUiState):
	var previous_state = _current_state
	_current_state = state
	
	if previous_state != null:
		previous_state.exit_state()
	
	_current_state.enter_state()


#region Node

func _process(delta):
	if _current_state != null:
		_current_state.update_state()


func _ready():
	play_state._controller = controller
	play_state._ui_manager = self
	win_state._controller = controller
	win_state._ui_manager = self


#endregion Node
