class_name MainMenuStartState
extends MainMenuState

@export var myScreen : ScreenLogic

func exit_game():
	myScreen.ExitApplication()


func go_to_credits():
	myScreen.GoToScreen(load("res://MainScenes/credits_screen.tscn"), {}, ScreenManager.TransitionStyle.TURN_PAGE)


func go_to_gallery():
	myScreen.GoToScreen(load("res://MainScenes/gallery_screen.tscn"), {}, ScreenManager.TransitionStyle.TURN_PAGE)


func go_to_messages():
	# TODO: Implement function
	print("go_to_messages is not implemented in MainMenuStartState")
	
func show_settings():
	myScreen.screenManager.ShowSettings()


func play():
	myScreen.GoToScreen(load("res://MainScenes/campaign_selection.tscn"), {}, ScreenManager.TransitionStyle.TURN_PAGE)


#region MainMenuState

func enter_state():
	pass


func exit_state():
	pass


func update_state():
	pass


#endregion MainMenuState
