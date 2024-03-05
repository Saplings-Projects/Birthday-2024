class_name SettingsWindow
extends Control

@export var animator : AnimationPlayer

var _gm: GameMaster

signal close_settings_window


func on_close_clicked():
	_gm.save_preferences()
	animator.play("PopupAnimations/Exit")
	await animator.animation_finished
	close_settings_window.emit()


#region Node

func _ready():
	_gm = get_node(GameMaster.GLOBAL_GAME_MASTER_NODE)
	animator.play("PopupAnimations/Enter")


#endregion Node
