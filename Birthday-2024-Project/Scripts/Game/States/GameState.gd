class_name GameState
extends Node2D

var manager: GameManager


func enter_state():
	pass


func exit_game():
	manager.myScreen.ExitApplication()


func exit_state():
	pass


func set_manager(manager: GameManager):
	self.manager = manager


func update_state():
	pass

