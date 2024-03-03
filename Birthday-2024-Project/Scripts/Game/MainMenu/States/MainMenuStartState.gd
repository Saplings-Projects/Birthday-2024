class_name MainMenuStartState
extends MainMenuState

@export var myScreen : ScreenLogic

func exit_game():
	myScreen.ExitApplication()


func go_to_credits():
	# TODO: Implement function
	print("go_to_credits is not implemented in MainMenuStartState")


func go_to_gallery():
	myScreen.GoToScreen(load("res://MainScenes/gallery_screen.tscn"), {}, true)


func go_to_messages():
	# TODO: Implement function
	print("go_to_messages is not implemented in MainMenuStartState")
	
func show_settings():
	myScreen.screenManager.ShowSettings()


func show_campaign_selection():
	myScreen.screenManager.GoToScreen(load("res://MainScenes/campaign_selection.tscn"), {}, true)


#region MainMenuState

func enter_state():
	pass


func exit_state():
	pass


func update_state():
	pass


#endregion MainMenuState
