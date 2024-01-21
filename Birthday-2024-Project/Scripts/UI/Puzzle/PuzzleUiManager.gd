class_name PuzzleUiManager
extends CanvasLayer

@export var controller: GameManager

@export_group("Screens")
@export var main_screen: Control

@export_group("States")
@export var play_state: PuzzleUiPlayState
@export var win_state: PuzzleUiWinState

@export_group("UI Elements")
@export var context_button: Button
@export var exit_button: Button
@export var reset_button: Button
@export var back_button: Button
@export var settings_button: Button
@export var win_text: Label

func show_hide_win_text(is_showing: bool):
	if is_showing:
		win_text.show()
	else:
		win_text.hide()

var _current_state: PuzzleUiState


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
	controller.myScreen.ShowSettings()


func _disable_all_screens():
	main_screen.hide()


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
