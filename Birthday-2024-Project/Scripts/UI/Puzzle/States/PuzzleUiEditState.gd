class_name PuzzleUiEditState
extends PuzzleUiState

@export var pieceLibrary : Control
@export var importPopup : Control
@export var inputField : TextEdit
@export var exportPopup : Control

var _state: GameEditState

func _on_exit_clicked():
	_state.exit_game()

func _on_reset_clicked():
	_state.reset_puzzle()

func _on_back_clicked():
	_state.back_to_menu()

func _on_play_mode_clicked():
	_state.go_to_play_mode()

func _on_show_library_clicked():
	if pieceLibrary.visible:
		pieceLibrary.hide()
	else:
		pieceLibrary.show()

func _on_import_clicked():
	inputField.text = ""
	_state.manager._can_interact = false
	importPopup.show()

func _on_confirm_import():
	_state.manager.grid.ImportLevel(inputField.text)
	importPopup.hide()
	_state.manager._can_interact = true

func _on_cancel_import():
	importPopup.hide()
	_state.manager._can_interact = true

func _on_export_clicked():
	_state.manager._can_interact = false
	DisplayServer.clipboard_set(_state.manager.grid.ExportLevel())
	exportPopup.show()

func _on_dismiss_export_popup():
	exportPopup.hide()
	_state.manager._can_interact = true

#region PuzzleUiState

func enter_state():
	var state = _controller.get_current_state()
	
	if not state is GameEditState:
		printerr("Puzzle is not in edit state", self)
		return
	
	_state = state
	
	_ui_manager.show_main_screen()
	
	var screen = _ui_manager.main_screen
	screen.show_hide_win_text(false)
	screen.context_button.text = "Library"
	screen.context_button.button_up.connect(_on_show_library_clicked)
	screen.exit_button.button_up.connect(_on_exit_clicked)
	screen.reset_button.button_up.connect(_on_reset_clicked)
	screen.back_button.button_up.connect(_on_back_clicked)
	screen.settings_button.button_up.connect(_on_settings_clicked)
	screen.edit_button.show()
	screen.edit_button.text = "Play"
	screen.edit_button.button_up.connect(_on_play_mode_clicked)
	screen.import_button.show()
	screen.import_button.button_up.connect(_on_import_clicked)
	screen.export_button.show()
	screen.export_button.button_up.connect(_on_export_clicked)


func exit_state():
	_state = null
	pieceLibrary.hide()
	var screen = _ui_manager.main_screen
	screen.import_button.hide()
	screen.export_button.hide()
	screen.context_button.button_up.disconnect(_on_show_library_clicked)
	screen.exit_button.button_up.disconnect(_on_exit_clicked)
	screen.reset_button.button_up.disconnect(_on_reset_clicked)
	screen.back_button.button_up.disconnect(_on_back_clicked)
	screen.settings_button.button_up.disconnect(_on_settings_clicked)
	screen.edit_button.button_up.disconnect(_on_play_mode_clicked)
	screen.import_button.button_up.disconnect(_on_import_clicked)
	screen.export_button.button_up.disconnect(_on_export_clicked)


func update_state():
	pass


#endregion PuzzleUiState
