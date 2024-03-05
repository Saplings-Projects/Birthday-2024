class_name GamePlayState
extends GameState


func reset_puzzle():
	manager.grid.ReloadLevel()

func go_to_edit_mode():
	manager.switch_to_edit_state()

func _on_grid_updated():
	if manager.grid.freeSpaces == 0:
		manager.switch_to_win_state()


#region GameState

func enter_state():
	print("Entering Game Play State")
	manager._can_interact = true
	manager.grid.gridMode = GridLogic.GridMode.PLAY
	
	if manager._previous_state is GameEditState:
		var updatedLevelSetup : LevelSetup = LevelSetup.new()
		updatedLevelSetup.jsonData = manager.grid.ExportLevel()
		manager.grid.LoadLevel(updatedLevelSetup)
	
	manager.grid.grid_updated.connect(_on_grid_updated)


func exit_state():
	print("Exiting Game Play State")
	
	manager.grid.grid_updated.disconnect(_on_grid_updated)


func update_state():
	pass


#endregion GameState
