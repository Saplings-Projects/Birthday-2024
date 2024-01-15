class_name GameEditState
extends GameState

@export var pieceLibrary : Control

func reset_puzzle():
	get_tree().reload_current_scene()

func back_to_menu():
	get_tree().change_scene_to_file("res://MainScenes/main_menu.tscn")#TODO remember where to go back (campaign or saplings' levels and go there)

func show_library():
	if pieceLibrary.visible:
		pieceLibrary.hide()
	else:
		pieceLibrary.show()


#region GameState

func enter_state():
	print("Entering Game Edit State")
	
	manager.grid.gridMode = GridLogic.GridMode.EDIT
	manager._can_interact = true


func exit_state():
	print("Exiting Game Edit State")


func update_state():
	pass


#endregion GameState
