class_name GameState
extends Node2D

var manager: GameManager

func next_puzzle():
	manager.go_to_next_level()

func back_to_menu():
	manager.go_to_main_menu()

func exit_game():
	manager.myScreen.ExitApplication()

func set_manager(manager: GameManager):
	self.manager = manager

func enter_state():
	pass

func exit_state():
	pass

func update_state():
	pass

