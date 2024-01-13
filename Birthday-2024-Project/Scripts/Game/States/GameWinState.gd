class_name GameWinState
extends GameState


var _gm: GameMaster


func next_puzzle():
	print("next_puzzle is not fully implemented", self)
	reset_puzzle() # TODO: DELETE THIS WHEN NO LONGER NEEDED.


func reset_puzzle():
	get_tree().reload_current_scene()


func back_to_menu():
	_gm.back_to_campaign_levels()


#region GameState

func enter_state():
	print("Entering Game Win State")
	manager._can_interact = false


func exit_state():
	print("Exiting Game Win State")


func update_state():
	pass # Do nothing


func _ready():
	_gm = get_node("/root/GlobalGameMaster")


#endregion GameState
