class_name MainMenuUiManager
extends CanvasLayer

signal initialized_event()
signal state_changed_event(state)

@export var screenLogic : ScreenLogic

@export_group("Screens")
@export var start_screen: MainMenuStartScreen
@export var campaign_select: CampaignSelectMenu
@export var campaign_levels: CampaignLevelsSelectMenu

@export_group("States")
@export var start_state: MainMenuUiStartState

var _current_state: MainMenuUiState
var _is_inititialized: bool

func show_settings_window():
	screenLogic.screenManager.ShowSettings()


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
	start_screen.hide()
	campaign_select.hide()
	campaign_levels.hide()


func _switch_state(state: MainMenuUiState):
	var previous_state = _current_state
	_current_state = state
	
	if previous_state != null:
		previous_state.exit_state()
	
	_current_state.enter_state()
	state_changed_event.emit(_current_state)


#region Node

func _process(delta):
	if not _is_inititialized:
		_is_inititialized = true
		initialized_event.emit()
		_switch_state(start_state)
		
	if _current_state != null:
		_current_state.update_state()


func _ready():
	start_state._ui_manager = self


#endregion None
