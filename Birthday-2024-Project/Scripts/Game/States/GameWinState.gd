class_name GameWinState
extends GameState

func next_puzzle(skipConfirm : bool = true):
	manager.go_to_next_level()

func back_to_level_select(askConfirm : bool = true):
	if manager._previous_state == manager.test_state:
		super.back_to_level_select()
	else:
		#skip confirmation
		manager.go_back_to_menu()

func _reset_puzzle():
	manager.grid.ReloadLevel()
	if manager._previous_state == manager.test_state:
		manager.switch_to_test_state()
	else:
		manager.switch_to_play_state()
	
func go_to_edit_mode():
	manager.switch_to_edit_state()

#region GameState

func enter_state():
	print("Entering Game Win State")
	manager._can_interact = false
	if manager._levelData != null:
		manager._gm.progression_tracker.MarkLevelCompleted(manager._levelData.resource_path)
		if manager.myScreen.transitionData[LevelsSelectMenu.IS_CAMPAIGN_KEY]:
			var thisLevelIndex : int = manager.myScreen.transitionData[LevelsSelectMenu.PASS_LEVEL_INDEX_KEY]
			manager._gm.progression_tracker.SetLatestCampaignLevelCompleted(thisLevelIndex)


func exit_state():
	print("Exiting Game Win State")


func update_state():
	pass # Do nothing


#endregion GameState
