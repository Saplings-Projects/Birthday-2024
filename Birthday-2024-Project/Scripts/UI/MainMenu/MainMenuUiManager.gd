class_name MainMenuUiManager
extends CanvasLayer


@export var controller: MainMenuController

@export_group("Screens")
@export var settings_window: SettingsWindow
@export var start_screen: MainMenuStartScreen
@export var campaign_select: CampaignSelectMenu
@export var campaign_levels: CampaignLevelsSelectMenu

@export_group("States")
@export var start_state: MainMenuUiStartState

var _current_state: MainMenuUiState


func hide_settings_window():
	settings_window.hide()


func on_main_menu_initialized():
	pass


func on_main_menu_state_changed(state: MainMenuState):
	if state is MainMenuStartState:
		_switch_state(start_state)
	else:
		printerr("Unhandled main menu state in main menu UI Manager")


func show_settings_window():
	settings_window.show()


func show_start_screen():
	_disable_all_screans()
	start_screen.show()


func show_campaign_select():
	_disable_all_screans()
	campaign_select.show()


func show_campaign_levels():
	_disable_all_screans()
	campaign_levels.show()


func _disable_all_screans():
	settings_window.hide()
	start_screen.hide()
	campaign_select.hide()
	campaign_levels.hide()


func _switch_state(state: MainMenuUiState):
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
	start_state._controller = controller
	start_state._ui_manager = self


#endregion None
