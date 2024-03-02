class_name MainMenuStartState
extends MainMenuState

@export var myScreen : ScreenLogic

func exit_game():
	myScreen.ExitApplication()


func go_to_credits():
	# TODO: Implement function
	print("go_to_credits is not implemented in MainMenuStartState")


func go_to_gallery():
	# TODO: Implement function
	print("go_to_gallery is not implemented in MainMenuStartState")
	
func show_settings():
	myScreen.screenManager.ShowSettings()


func play():
	myScreen.GoToScreen(load("res://MainScenes/main_level.tscn"), {}, ScreenManager.TransitionStyle.TURN_PAGE)


#region MainMenuState

func enter_state():
	pass


func exit_state():
	pass


func update_state():
	pass


#endregion MainMenuState
