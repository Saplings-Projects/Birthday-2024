class_name CampaignSelectController
extends Node2D


@export_group("States")
@export var empty_state: CampaignSelectEmptyState
@export var start_state: CampaignSelectStartState

var _current_state: CampaignSelectState
var _is_inititialized: bool
var _previous_state: CampaignSelectState

signal initialized_event()
signal state_changed_event(state)


func get_current_state() -> CampaignSelectState:
	return _current_state


func switch_to_start_state():
	_switch_state(start_state)


func _switch_state(state: CampaignSelectState):
	_previous_state = _current_state
	_current_state = state
	
	if _previous_state != null:
		_previous_state.exit_state()
	
	_current_state.enter_state()
	
	state_changed_event.emit(_current_state)


#region Node

func _process(delta):
	if not _is_inititialized:
		_is_inititialized = true
		
		initialized_event.emit()
		
		# Pick the appropriate state based on game data (e.g. exiting a level or starting up)
		switch_to_start_state()
	
	_current_state.update_state()


func _ready():
	# State
	_current_state = empty_state
	empty_state.controller = self
	start_state.controller = self


#endregion Node
