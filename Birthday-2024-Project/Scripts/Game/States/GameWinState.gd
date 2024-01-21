class_name GameWinState
extends GameState


func next_puzzle():
	print("next_puzzle is not fully implemented", self)
	reset_puzzle() # TODO: DELETE THIS WHEN NO LONGER NEEDED.


func reset_puzzle():
	get_tree().reload_current_scene()


func back_to_menu():
	manager.go_to_main_menu()
	#TODO remember where to go back (campaign or saplings' levels and go there)


#region GameState

func enter_state():
	print("Entering Game Win State")
	manager._can_interact = false


func exit_state():
	print("Exiting Game Win State")


func update_state():
	pass # Do nothing


#endregion GameState
