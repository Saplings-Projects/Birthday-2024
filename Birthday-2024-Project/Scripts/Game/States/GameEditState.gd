class_name GameEditState
extends GameState

func reset_puzzle():
	manager.grid.ClearLevel()

func back_to_menu():
	get_tree().change_scene_to_file("res://MainScenes/main_menu.tscn")#TODO remember where to go back (campaign or saplings' levels and go there)

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
