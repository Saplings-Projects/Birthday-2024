class_name MainMenuStartState
extends MainMenuState


func exit_game():
	get_tree().quit()


func go_to_credits():
	# TODO: Implement function
	print("go_to_credits is not implemented in MainMenuStartState")


func go_to_gallery():
	# TODO: Implement function
	print("go_to_gallery is not implemented in MainMenuStartState")


func play():
	get_tree().change_scene_to_file("res://MainScenes/main_level.tscn")


#region MainMenuState

func enter_state():
	pass


func exit_state():
	pass


func update_state():
	pass


#endregion MainMenuState
