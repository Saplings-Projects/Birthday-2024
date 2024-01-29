class_name GameEditState
extends GameState

func reset_puzzle():
	manager.grid.ClearLevel()

func back_to_menu():
	manager.go_to_main_menu()

func go_to_play_mode():
	manager.switch_to_play_state()


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
