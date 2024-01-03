class_name PuzzleMainScreen
extends Control


@export_group("UI Elements")
@export var context_button: Button
@export var reset_button: Button
@export var back_button: Button
@export var win_text: Label


func show_hide_win_text(is_showing: bool):
	if is_showing:
		win_text.show()
	else:
		win_text.hide()

