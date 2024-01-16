class_name PuzzleUiPlayState
extends PuzzleUiState


var _state: GamePlayState


func _on_exit_clicked():
	_state.exit_game()

func _on_reset_clicked():
	_state.reset_puzzle()

func _on_back_clicked():
	_state.back_to_menu()

func _on_skip_clicked():
	_state.skip_puzzle()

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
	screen.context_button.text = "Skip"
	screen.context_button.button_up.connect(_on_skip_clicked)
	screen.exit_button.button_up.connect(_on_exit_clicked)
	screen.reset_button.button_up.connect(_on_reset_clicked)
	screen.back_button.button_up.connect(_on_back_clicked)
	screen.settings_button.button_up.connect(_on_settings_clicked)
	_ui_manager.edit_button.show()
	_ui_manager.edit_button.text = "Edit"
	_ui_manager.edit_button.button_up.connect(_on_edit_mode_clicked)


func exit_state():
	_state = null
	
	var screen = _ui_manager.main_screen
	screen.context_button.button_up.disconnect(_on_skip_clicked)
	screen.exit_button.button_up.disconnect(_on_exit_clicked)
	screen.reset_button.button_up.disconnect(_on_reset_clicked)
	screen.back_button.button_up.disconnect(_on_back_clicked)
	screen.settings_button.button_up.disconnect(_on_settings_clicked)
	_ui_manager.edit_button.button_up.disconnect(_on_edit_mode_clicked)


func update_state():
	pass


#endregion PuzzleUiState
