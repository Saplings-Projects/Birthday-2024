class_name GalleryScreen
extends Control

@export var myScreen : ScreenLogic
@export var piece : TextureRect
@export var pieces : Array[TextureRect] 
@export var description : Label
@export var descriptions : Array[String]
@export var artist_credit : Label
@export var piece_name : Label
@export var piece_names: Array[String]
@export var page_num : Label

var gallery_tracker : int = 0

signal back_to_main_menu
signal exit_game
signal open_settings_window

func _on_exit_button_button_up():
	myScreen.ExitApplication()

func _on_back_button_button_up():
	myScreen.GoToScreen(load("res://MainScenes/main_menu.tscn"), {}, ScreenManager.TransitionStyle.BACK_PAGE)

func _on_settings_button_button_up():
	myScreen.ShowSettings()

func _on_next_art_button_button_up():
	myScreen.screenManager.ShowTransitionAnimation(ScreenManager.TransitionStyle.TURN_PAGE, _transition_page_next, _animation_finished)

func _transition_page_next():
	pieces[gallery_tracker].hide()
	gallery_tracker += 1
	if gallery_tracker > (pieces.size() - 1) : 
		gallery_tracker = 0;
	_update_UI()

func _on_previous_art_button_button_up():
	myScreen.screenManager.ShowTransitionAnimation(ScreenManager.TransitionStyle.BACK_PAGE, _transition_page_back, _animation_finished)

func _transition_page_back():
	pieces[gallery_tracker].hide()
	gallery_tracker -= 1
	if gallery_tracker < 0 : 
		gallery_tracker = pieces.size() - 1
	_update_UI()

func _update_UI():
	pieces[gallery_tracker].visible = true
	piece_name.text = piece_names[gallery_tracker]
	description.text = descriptions[gallery_tracker]
	_change_artist_credit()
	page_num.text = str(gallery_tracker + 1, "/", pieces.size())

func _animation_finished():
	pass

func _change_artist_credit():
	match gallery_tracker:
		0, 1, 2, 3, 4, 5, 6, 7, 20:
			artist_credit.text = "Art by: Lunar"
		8, 12, 14: 
			artist_credit.text = "Art by: EndyStarBoy"
		9, 10, 13, 18:
			artist_credit.text = "Art by: crashairsprig"
		11, 15, 19:
			artist_credit.text = "Art by: mpmrpjb"
		16, 17:
			artist_credit.text = "Art by: Cyanophycée"
		21, 22: 
			artist_credit.text = "Art by: HDAK art"

func _ready():
	_update_UI()
