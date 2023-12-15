class_name GameWinState
extends GameState


func next_puzzle():
	print("next_puzzle is not fully implemented", self)
	reset_puzzle() # TODO: DELETE THIS WHEN NO LONGER NEEDED.


func reset_puzzle():
	get_tree().reload_current_scene()


#region GameState

func enter_state():
	print("Entering Game Win State")


func exit_state():
	print("Exiting Game Win State")


func update_state():
	pass # Do nothing


#endregion GameState
