class_name PuzzleUiManager
extends CanvasLayer


@export_group("UI Elements")
@export var main_screen: PuzzleMainScreen

@export_group("States")
@export var play_state: PuzzleUiPlayState
@export var win_state: PuzzleUiWinState

var _current_state: PuzzleUiState


func on_puzzle_initialized():
	pass


func on_puzzle_state_changed(state: GameState):
	match state:
		GamePlayState:
			_switch_state(play_state)
		
		GameWinState:
			_switch_state(win_state)
		
		_:
			printerr("Unhandled puzzle state in puzzle UI Manager", self)


func show_main_screen():
	_disable_all_screens()
	main_screen.show()


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


#endregion Node
