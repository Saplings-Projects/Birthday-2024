class_name GameEditState
extends GameState

func reset_puzzle():
	manager.myScreen.ScreenEnter.connect(ResetConfirmation)
	manager.myScreen.ShowConfirmationPopup("Restart", "Are you sure you want clear all pieces?", "Yes", "No")

func _reset_puzzle():
	manager.grid.ClearLevel()

func go_to_test_mode():
	manager.switch_to_test_state()


#region GameState

func enter_state():
	print("Entering Game Edit State")
	
	manager.grid.gridMode = GridLogic.GridMode.EDIT
	manager._can_interact = true
	manager.grid.ReloadLevel()


func exit_state():
	print("Exiting Game Edit State")


func update_state():
	pass


#endregion GameState
