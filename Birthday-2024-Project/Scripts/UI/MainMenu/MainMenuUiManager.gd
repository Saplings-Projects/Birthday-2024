class_name MainMenuUiManager
extends Control

@export var controller: MainMenuController
@export var screenLogic : ScreenLogic
@export var titleNode : Control
@export var animator : AnimationPlayer

@export_group("Screens")
@export var start_screen: MainMenuStartScreen

@export_group("States")
@export var start_state: MainMenuUiStartState

var _current_state: MainMenuUiState
var _playOnce : bool = false

func PlayIntro():
	if _playOnce:
		_playOnce = false
		animator.play("TitleIntro")
		screenLogic.screenManager.StartBGM()
		await get_tree().create_timer(0.05).timeout
		titleNode.visible = true

func on_main_menu_initialized():
	_playOnce = true

func on_main_menu_state_changed(state: MainMenuState):
	if state is MainMenuStartState:
		_switch_state(start_state)
	else:
		printerr("Unhandled main menu state in main menu UI Manager")


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
