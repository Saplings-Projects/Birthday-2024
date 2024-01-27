class_name GameState
extends Node2D


var manager: GameManager


func enter_state():
	pass


func exit_game():
	get_tree().quit()


func exit_state():
	pass


func set_manager(manager: GameManager):
	self.manager = manager


func update_state():
	pass

