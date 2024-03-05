class_name GameState
extends Node2D

var manager: GameManager

func next_puzzle():
	manager.go_to_next_level()

func reset_puzzle():
	manager.myScreen.ScreenEnter.connect(ResetConfirmation)
	manager.myScreen.ShowConfirmationPopup("Restart?", "Are you sure you want to restart from the beginning?", "Yes", "No")
	
func ResetConfirmation():
	manager.myScreen.ScreenEnter.disconnect(ResetConfirmation)
	if manager.myScreen.transitionData[ConfirmationPopupController.RESPONSE_KEY]:
		_reset_puzzle()

func _reset_puzzle():
	manager.grid.ReloadLevel()

func back_to_menu():
	manager.go_to_main_menu()

func exit_game():
	manager.myScreen.ExitApplication()

func set_manager(manager: GameManager):
	self.manager = manager

func enter_state():
	pass

func exit_state():
	pass

func update_state():
	pass

