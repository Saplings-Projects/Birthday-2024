class_name PuzzleUiWinState
extends PuzzleUiState


var _state: GameWinState


#region PuzzleUiState

func enter_state():
	var state = _controller.get_current_state()
	
	if not state is GameWinState:
		printerr("Puzzle is not in win state", self)
		return
	
	_state = state
	
	_ui_manager.show_main_screen()
	
	var screen = _ui_manager.main_screen
	screen.show_hide_win_text(true)
	screen.skip_button.button_up.connect(_state.next_puzzle)
	screen.exit_button.button_up.connect(_state.exit_game)
	screen.reset_button.button_up.connect(_state.reset_puzzle)
	screen.back_button.button_up.connect(_state.back_to_level_select)
	screen.settings_button.button_up.connect(_on_settings_clicked)
	screen.edit_button.hide()
	screen.library_button.hide()


func exit_state():
	var screen = _ui_manager.main_screen
	screen.skip_button.button_up.disconnect(_state.next_puzzle)
	screen.exit_button.button_up.disconnect(_state.exit_game)
	screen.reset_button.button_up.disconnect(_state.reset_puzzle)
	screen.back_button.button_up.disconnect(_state.back_to_level_select)
	screen.settings_button.button_up.disconnect(_on_settings_clicked)
	_state = null


func update_state():
	pass


#endregion PuzzleUiState
