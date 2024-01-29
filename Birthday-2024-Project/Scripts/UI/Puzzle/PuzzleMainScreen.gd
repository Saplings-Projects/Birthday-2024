class_name PuzzleMainScreen
extends Control


@export_group("UI Elements")
@export var context_button: Button
@export var exit_button: Button
@export var reset_button: Button
@export var back_button: Button
@export var settings_button: Button
@export var win_text: Label
@export var edit_button: Button
@export var import_button: Button
@export var export_button: Button


func show_hide_win_text(is_showing: bool):
	if is_showing:
		win_text.show()
	else:
		win_text.hide()

