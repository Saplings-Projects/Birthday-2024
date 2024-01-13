class_name MainMenuUiStartState
extends MainMenuUiState


var _state: MainMenuStartState


func _on_credits_clicked():
	_state.go_to_credits()


func _on_exit_clicked():
	_state.exit_game()


func _on_gallery_clicked():
	_state.go_to_gallery()


func _on_play_clicked():
	_ui_manager.show_campaign_select()


func _on_settings_clicked():
	_ui_manager.show_settings_window()


func _on_campaign_levels_clicked():
	_ui_manager.show_campaign_levels()


func _on_saplings_levels_clicked():
	print("_on_saplings_levels_clicked is not implemented in MainMenuUiStartState")


func _on_back_to_main_menu_clicked():
	_ui_manager.show_start_screen()


func _on_back_to_campaign_select_menu_clicked():
	_ui_manager.show_campaign_select()


func _on_level_selected():
	_state.play()


#region MainMenuUiState

func enter_state():
	var state = _controller.get_current_state()
	
	if not state is MainMenuStartState:
		printerr("Main menu is not in start state")
		return
	
	_state = state
	
	
	_ui_manager.show_start_screen()
	
	var screen = _ui_manager.start_screen
	screen.credits_button.button_up.connect(_on_credits_clicked)
	screen.exit_button.button_up.connect(_on_exit_clicked)
	screen.gallery_button.button_up.connect(_on_gallery_clicked)
	screen.play_button.button_up.connect(_on_play_clicked)
	screen.settings_button.button_up.connect(_on_settings_clicked)


func exit_state():
	_state = null
	
	var screen = _ui_manager.start_screen
	screen.credits_button.button_up.disconnect(_on_credits_clicked)
	screen.exit_button.button_up.disconnect(_on_exit_clicked)
	screen.gallery_button.button_up.disconnect(_on_gallery_clicked)
	screen.play_button.button_up.disconnect(_on_play_clicked)
	screen.settings_button.button_up.disconnect(_on_settings_clicked)


func update_state():
	pass


#endregion MainMenuUiState
