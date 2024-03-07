class_name PuzzleUiPlayState
extends PuzzleUiState


var _state: GamePlayState


func _on_edit_mode_clicked():
	_state.go_to_edit_mode()

#region PuzzleUiState

func enter_state():
	var state = _controller.get_current_state()
	
	if not state is GamePlayState:
		printerr("Puzzle is not in play state", self)
		return
	
	_state = state
	
	_ui_manager.show_main_screen()
	
	var screen = _ui_manager.main_screen
	screen.show_hide_win_text(false)
	screen.skip_button.button_up.connect(_state.next_puzzle)
	screen.exit_button.button_up.connect(_state.exit_game)
	screen.reset_button.button_up.connect(_state.reset_puzzle)
	screen.back_button.button_up.connect(_state.back_to_level_select)
	screen.settings_button.button_up.connect(_on_settings_clicked)
	screen.edit_button.show()
	screen.edit_button.text = "Edit"
	screen.edit_button.button_up.connect(_on_edit_mode_clicked)
	screen.library_button.hide()


func exit_state():
	var screen = _ui_manager.main_screen
	screen.skip_button.button_up.disconnect(_state.next_puzzle)
	screen.exit_button.button_up.disconnect(_state.exit_game)
	screen.reset_button.button_up.disconnect(_state.reset_puzzle)
	screen.back_button.button_up.disconnect(_state.back_to_level_select)
	screen.settings_button.button_up.disconnect(_on_settings_clicked)
	screen.edit_button.button_up.disconnect(_on_edit_mode_clicked)
	_state = null


func update_state():
	pass


#endregion PuzzleUiState
