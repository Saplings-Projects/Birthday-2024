class_name ScreenManager
extends Node

enum TransitionStyle {
	NONE,
	TURN_PAGE,
	BACK_PAGE
}

@export var popupRoot : CanvasLayer
@export var screenTexture : TextureRect
@export var bgmPlayer : AudioStreamPlayer

var lastScreen : String
var _screenStack : Array[Node]
@onready var transition = $TransitionLayer/AnimationPlayer

signal AnimationFinished

var _transitionFinishCallable : Callable
var _animationActive : bool = false

func GoToScreen(screen : PackedScene, data : Dictionary, transitionStyle: TransitionStyle):
	if _animationActive:
		return

	if transitionStyle != TransitionStyle.NONE:
		_animationActive = true
		var screenCapture = get_viewport().get_texture().get_image()
		var tex = ImageTexture.create_from_image(screenCapture)
		screenTexture.texture = tex
		AnimationFinished.connect(_completeSceneTransition)
		match transitionStyle:
			TransitionStyle.TURN_PAGE:
				transition.play("page_turn")
			TransitionStyle.BACK_PAGE:
				transition.play("page_turn_back")
		await get_tree().create_timer(0.05).timeout
	
	var newScreen = screen.instantiate()
	var screenLogic : ScreenLogic = newScreen as ScreenLogic
	
	if screenLogic.clearScreenStack:
		while _screenStack.size() > 0:
			_closeTopScreen()
	
	screenLogic.screenManager = self
	screenLogic.transitionData = data
	popupRoot.add_child(newScreen)
	_screenStack.push_back(newScreen)
	
	if transitionStyle == TransitionStyle.NONE:
		screenLogic.ScreenEnter.emit()

func TransitionAnimationFinished():
	_animationActive = false
	AnimationFinished.emit()

func IsTopScreen(screen : ScreenLogic) -> bool:
	var topScreen : ScreenLogic = _screenStack.back() as ScreenLogic
	return screen == topScreen
	
func CloseTopScreen(data : Dictionary):
	if _screenStack.size() == 1:
		printerr("ERROR: cannot close last screen")
		return
	_closeTopScreen()
	var topScreen : ScreenLogic = _screenStack.back() as ScreenLogic
	topScreen.transitionData = data
	topScreen.ScreenEnter.emit()

func StartBGM():
	if bgmPlayer.playing == false:
		#var bgmFadeIn = get_tree().create_tween()
		#bgmFadeIn.tween_property(bgmPlayer, "volume_db", 0, 2)
		#bgmFadeIn.set_ease(Tween.EASE_IN)
		bgmPlayer.play()

func ShowSettings(existingData : Dictionary = {}):
	GoToScreen(load("res://MainScenes/settings_popup.tscn"), existingData, TransitionStyle.NONE)

func ShowTextPopup(title : String, body : String, existingData : Dictionary = {}, confirm : String = "Close"):
	var popupParameters = existingData
	popupParameters[TextPopupController.TITLE_KEY] = title
	popupParameters[TextPopupController.BODY_KEY] = body
	popupParameters[TextPopupController.CONFIRM_KEY] = confirm
	GoToScreen(load("res://MainScenes/text_popup.tscn"), popupParameters, TransitionStyle.NONE)

func ShowConfirmationPopup(title : String, body : String, existingData : Dictionary = {}, confirm : String = "Confirm", cancel : String = "Cancel"):
	var popupParameters = existingData
	popupParameters[TextPopupController.TITLE_KEY] = title
	popupParameters[TextPopupController.BODY_KEY] = body
	popupParameters[TextPopupController.CONFIRM_KEY] = confirm
	popupParameters[ConfirmationPopupController.CANCEL_KEY] = cancel
	GoToScreen(load("res://MainScenes/confirmation_popup.tscn"), popupParameters, TransitionStyle.NONE)

func ShowDisplayPopup(title : String, body : String, displayPieces : Array[PackedScene], existingData : Dictionary = {}, confirm : String = "Close"):
	var popupParameters = existingData
	popupParameters[TextPopupController.TITLE_KEY] = title
	popupParameters[TextPopupController.BODY_KEY] = body
	popupParameters[TextPopupController.CONFIRM_KEY] = confirm
	popupParameters[DisplayPopupController.PIECES_KEY] = displayPieces
	GoToScreen(load("res://MainScenes/display_popup.tscn"), popupParameters, TransitionStyle.NONE)

func ShowTransitionAnimation(transitionStyle: TransitionStyle, animationStarted : Callable, animationFinished : Callable):
	if _animationActive:
		return

	var screenCapture = get_viewport().get_texture().get_image()
	var tex = ImageTexture.create_from_image(screenCapture)
	screenTexture.texture = tex
	_transitionFinishCallable = animationFinished
	AnimationFinished.connect(_completeTransitionAnimation)
	match transitionStyle:
		TransitionStyle.TURN_PAGE:
			transition.play("page_turn")
		TransitionStyle.BACK_PAGE:
			transition.play("page_turn_back")
	await get_tree().create_timer(0.05).timeout
	animationStarted.call()

func _ready():
	GoToScreen(load("res://MainScenes/splash_screen.tscn"), {}, TransitionStyle.NONE)

func _closeTopScreen():
	var oldScreen : Node = _screenStack.pop_back()
	var screenLogic : ScreenLogic = oldScreen as ScreenLogic
	screenLogic.ScreenExit.emit()
	lastScreen = oldScreen.name
	oldScreen.queue_free()

func _completeSceneTransition():
	AnimationFinished.disconnect(_completeSceneTransition)
	var screenLogic : ScreenLogic = _screenStack.back()
	screenLogic.ScreenEnter.emit()

func _completeTransitionAnimation():
	AnimationFinished.disconnect(_completeTransitionAnimation)
	if _transitionFinishCallable != null:
		_transitionFinishCallable.call()
