class_name PuzzleUiWinState
extends PuzzleUiState


var _state: GameWinState


func _on_exit_clicked():
	_state.exit_game()

func _on_next_clicked():
	_state.next_puzzle()

func _on_reset_clicked():
	_state.reset_puzzle()

func _on_back_clicked():
	_state.back_to_menu()


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
	screen.context_button.text = "Next"
	screen.context_button.button_up.connect(_on_next_clicked)
	screen.exit_button.button_up.connect(_on_exit_clicked)
	screen.reset_button.button_up.connect(_on_reset_clicked)
	screen.back_button.button_up.connect(_on_back_clicked)
	screen.settings_button.button_up.connect(_on_settings_clicked)
	screen.edit_button.hide()


func exit_state():
	_state = null
	
	var screen = _ui_manager.main_screen
	screen.context_button.button_up.disconnect(_on_next_clicked)
	screen.exit_button.button_up.disconnect(_on_exit_clicked)
	screen.reset_button.button_up.disconnect(_on_reset_clicked)
	screen.settings_button.button_up.disconnect(_on_settings_clicked)
	screen.back_button.button_up.disconnect(_on_back_clicked)
	screen.settings_button.button_up.disconnect(_on_settings_clicked)


func update_state():
	pass


#endregion PuzzleUiState
