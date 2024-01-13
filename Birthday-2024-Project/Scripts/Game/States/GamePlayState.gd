class_name GamePlayState
extends GameState

var _gm: GameMaster

func reset_puzzle():
	get_tree().reload_current_scene()

func back_to_menu():
	_gm.back_to_campaign_levels()

func skip_puzzle():
	print("skip_puzzle is not fully implemented", self)
	reset_puzzle() # TODO: DELETE THIS WHEN NO LONGER NEEDED.


func _on_grid_updated():
	if manager.grid.freeSpaces == 0:
		manager.switch_to_win_state()


#region GameState

func enter_state():
	print("Entering Game Play State")
	
	manager._can_interact = true
	manager.grid.grid_updated.connect(_on_grid_updated)


func exit_state():
	print("Exiting Game Play State")
	
	manager.grid.grid_updated.disconnect(_on_grid_updated)


func update_state():
	pass


func _ready():
	_gm = get_node("/root/GlobalGameMaster")

#endregion GameState
