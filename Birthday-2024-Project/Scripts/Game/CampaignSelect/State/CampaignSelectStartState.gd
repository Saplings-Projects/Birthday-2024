class_name CampaignSelectStartState
extends CampaignSelectState

@export var myScreen : ScreenLogic

func exit_game():
	myScreen.ExitApplication()
	
func show_settings():
	myScreen.screenManager.ShowSettings()


#func show_campaign_selection():
	#myScreen.screenManager.ShowCampaignSelection()


#region CampaignSelectState

func enter_state():
	pass


func exit_state():
	pass


func update_state():
	pass


#endregion CampaignSelectState
