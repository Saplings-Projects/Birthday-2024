class_name MainMenuUiStartState
extends MainMenuUiState

@export var myScreen : ScreenLogic


func _on_credits_clicked():
	# TODO: Implement function
	print("go_to_credits is not implemented in MainMenuUiStartState")


func _on_exit_clicked():
	myScreen.ExitApplication()


func _on_gallery_clicked():
	# TODO: Implement function
	print("go_to_gallery is not implemented in MainMenuUiStartState")


func _on_play_clicked():
	_ui_manager.show_campaign_select()


func _on_settings_clicked():
	myScreen.screenManager.ShowSettings()
	#_ui_manager.show_settings_window()


func _on_campaign_levels_clicked():
	_ui_manager.show_campaign_levels()


func _on_saplings_levels_clicked():
	print("_on_saplings_levels_clicked is not implemented in MainMenuUiStartState")


func _on_back_to_main_menu_clicked():
	_ui_manager.show_start_screen()


func _on_back_to_campaign_select_menu_clicked():
	_ui_manager.show_campaign_select()


func _on_level_selected():
	get_tree().change_scene_to_file("res://MainScenes/main_level.tscn")


#region MainMenuUiState

func enter_state():
	_ui_manager.show_start_screen()
	
	var screen = _ui_manager.start_screen
	screen.credits_button.button_up.connect(_on_credits_clicked)
	screen.exit_button.button_up.connect(_on_exit_clicked)
	screen.gallery_button.button_up.connect(_on_gallery_clicked)
	screen.play_button.button_up.connect(_on_play_clicked)
	screen.settings_button.button_up.connect(_on_settings_clicked)


func exit_state():	
	var screen = _ui_manager.start_screen
	screen.credits_button.button_up.disconnect(_on_credits_clicked)
	screen.exit_button.button_up.disconnect(_on_exit_clicked)
	screen.gallery_button.button_up.disconnect(_on_gallery_clicked)
	screen.play_button.button_up.disconnect(_on_play_clicked)
	screen.settings_button.button_up.disconnect(_on_settings_clicked)


func update_state():
	pass


#endregion MainMenuUiState
