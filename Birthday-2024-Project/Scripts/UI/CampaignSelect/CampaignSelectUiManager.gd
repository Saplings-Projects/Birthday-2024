class_name CampaignSelectUiManager
extends Control

@export var controller: CampaignSelectController
@export var screenLogic : ScreenLogic

@export_group("States")
@export var start_state: CampaignSelectUiStartState

var _current_state: CampaignSelectUiState

func on_campaign_select_initialized():
	pass

func on_campaign_select_state_changed(state: CampaignSelectState):
	if state is CampaignSelectStartState:
		_switch_state(start_state)
	else:
		printerr("Unhandled campaign select state in campaign select UI Manager")


func _switch_state(state: CampaignSelectUiState):
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
