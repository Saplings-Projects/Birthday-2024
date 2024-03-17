extends AnimationPlayer
class_name UIButtonAnimations

enum ButtonState {
	INITIAL,
	IDLE,
	ENTER,
	HOVER,
	DOWN,
	EXIT,
	PRESS
}

@export var introAnim : String
@export var onIdle : String
@export var onEnter : String
@export var onHover : String
@export var onDown : String
@export var onExit : String
@export var onPress : String

signal pressAnimFinished

var awaitingSignal : bool
var myButton : Button
var myState : ButtonState
var buttonDown : bool
var queueEnter : bool

func startOnScreenEnter():
	awaitingSignal = false
	
	if !introAnim.is_empty():
		play(introAnim)

func onButtonEnter():
	if myState == ButtonState.PRESS or myState == ButtonState.INITIAL:
		queueEnter = true
		return
		
	myState = ButtonState.ENTER
	if !onEnter.is_empty():
		play(onEnter)

func onButtonExit():
	if myState == ButtonState.PRESS or myState == ButtonState.INITIAL:
		queueEnter = false
		return
		
	myState = ButtonState.EXIT
	if !onExit.is_empty():
		play(onExit)

func onButtonDown():
	buttonDown = true
	if myState == ButtonState.PRESS or myState == ButtonState.INITIAL:
		return
	
	myState = ButtonState.DOWN
	if !onDown.is_empty():
		play(onDown)

func onButtonUp():
	buttonDown = false
	
func onButtonPressed():
	if myState == ButtonState.PRESS or myState == ButtonState.INITIAL:
		return
	
	myState = ButtonState.PRESS
	if !onPress.is_empty():
		play(onPress)

func _ready():
	buttonDown = false
	queueEnter = false
	awaitingSignal = true
	myState = ButtonState.INITIAL
	
	myButton = get_parent() as Button
	myButton.mouse_entered.connect(onButtonEnter)
	myButton.mouse_exited.connect(onButtonExit)
	myButton.button_down.connect(onButtonDown)
	myButton.button_up.connect(onButtonUp)
	myButton.pressed.connect(onButtonPressed)

func _process(delta):
	if awaitingSignal:
		return
	
	match myState:
		ButtonState.INITIAL:
			if is_playing():
				return
			
			if queueEnter:
				myState = ButtonState.ENTER
				onButtonEnter()
			else:
				myState = ButtonState.IDLE
				if !onIdle.is_empty():
					play(onIdle)
		ButtonState.IDLE:
			pass
		ButtonState.ENTER:
			if is_playing():
				return
			
			if buttonDown:
				myState = ButtonState.DOWN
				if !onDown.is_empty():
					play(onDown)
			else:
				myState = ButtonState.HOVER
				if !onHover.is_empty():
					play(onHover)
		ButtonState.HOVER:
			pass
		ButtonState.DOWN:
			pass
		ButtonState.EXIT:
			if is_playing():
				return
			
			myState = ButtonState.IDLE
			if !onIdle.is_empty():
				play(onIdle)
		ButtonState.PRESS:
			if is_playing():
				return
			
			pressAnimFinished.emit()
			
			myState = ButtonState.INITIAL
			if queueEnter:
				onButtonEnter()
	
