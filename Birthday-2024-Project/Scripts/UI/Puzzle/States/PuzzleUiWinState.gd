class_name PuzzleUiWinState
extends PuzzleUiState


var _state: GameWinState

func _next_puzzle():
	_state.next_puzzle()

func _on_edit_mode_clicked():
	_state.go_to_edit_mode()

#region PuzzleUiState

func enter_state():
	var state = _controller.get_current_state()
	
	if not state is GameWinState:
		printerr("Puzzle is not in win state", self)
		return
	
	_state = state
	
	_ui_manager.show_main_screen()
	
	var screen = _ui_manager.main_screen
	screen.play_win_animation()
	#screen.skip_button.set_theme(load("res://Art/UI/Themes/Next_Level_Button_theme.tres"))
	screen.skip_button.pressed.connect(_state.next_puzzle)
	screen.exit_button.pressed.connect(_state.exit_game)
	screen.reset_button.pressed.connect(_state.reset_puzzle)
	screen.back_button.pressed.connect(_state.back_to_level_select)
	screen.settings_button.pressed.connect(_on_settings_clicked)
	screen.edit_button.pressed.connect(_on_edit_mode_clicked)
	screen.library_anchor.hide()


func exit_state():
	var screen = _ui_manager.main_screen
	screen.hide_win_animation()
	screen.skip_button.set_theme(load("res://Art/UI/Themes/Skip_Button_theme.tres"))
	screen.skip_button.pressed.disconnect(_state.next_puzzle)
	screen.exit_button.pressed.disconnect(_state.exit_game)
	screen.reset_button.pressed.disconnect(_state.reset_puzzle)
	screen.back_button.pressed.disconnect(_state.back_to_level_select)
	screen.settings_button.pressed.disconnect(_on_settings_clicked)
	screen.edit_button.pressed.disconnect(_on_edit_mode_clicked)
	_state = null


func update_state():
	pass


#endregion PuzzleUiState
