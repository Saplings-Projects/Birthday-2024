class_name CampaignSelectUiStartState
extends CampaignSelectUiState

var _state: CampaignSelectStartState


func _on_exit_clicked():
	_state.exit_game()


func _on_settings_clicked():
	_state.show_settings()


#region CampaignSelectUiState

func enter_state():
	var state = _controller.get_current_state()

	if not state is CampaignSelectStartState:
		printerr("Campaign select is not in start state")
		return

	_state = state

	_ui_manager.show_start_screen()
	
	var screen = _ui_manager.start_screen
	screen.exit_button.button_up.connect(_on_exit_clicked)
	screen.settings_button.button_up.connect(_on_settings_clicked)


func exit_state():	
	_state = null
	var screen = _ui_manager.start_screen
	screen.exit_button.button_up.disconnect(_on_exit_clicked)
	screen.settings_button.button_up.disconnect(_on_settings_clicked)


func update_state():
	pass


#endregion CampaignSelectUiState
