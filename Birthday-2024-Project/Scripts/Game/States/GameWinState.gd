class_name GameWinState
extends GameState


func next_puzzle():
	manager.go_to_next_level()


func reset_puzzle():
	manager.grid.ReloadLevel()
	manager.switch_to_play_state()


func back_to_menu():
	manager.go_to_main_menu()


#region GameState

func enter_state():
	print("Entering Game Win State")
	manager._can_interact = false
	if manager.myScreen.transitionData[LevelsSelectMenu.IS_CAMPAIGN_KEY]:
		var thisLevelIndex : int = manager.myScreen.transitionData[LevelsSelectMenu.PASS_LEVEL_INDEX_KEY]
		manager._gm.progression_tracker.SetLatestCampaignLevelCompleted(thisLevelIndex)
	else:
		manager._gm.progression_tracker.MarkLevelCompleted(manager._levelData.levelName)


func exit_state():
	print("Exiting Game Win State")


func update_state():
	pass # Do nothing


#endregion GameState
