class_name MessageGallery
extends Control

const LARGE_MESSAGE_SIZE : int = 2
const SMALL_MESSAGE_SIZE : int = 1

@export var smallMessageThreshold : int = 250
@export var myScreen : ScreenLogic
@export var messageLibrary : LevelLibrary
@export var pageNumberText : Label

@export var topLeftSmallMsgBox : Label
@export var topLeftAuthorText : Label
@export var bottomLeftSmallMsgBox : Label
@export var bottomLeftAuthorText : Label
@export var leftBigMsgBox : Label
@export var leftAuthorText : Label
@export var topRightSmallMsgBox : Label
@export var topRightAuthorText : Label
@export var bottomRightSmallMsgBox : Label
@export var bottomRightAuthorText : Label
@export var rightBigMsgBox : Label
@export var rightAuthorText : Label

var _currentPage : int
var _pageBreakdown : Array[MessagePageHandler]

func LoadPage():
	#var currentSize = 0
	#pageNumberText.text = str(_currentPage + 1, "/", _pageBreakdown.size())
	#
	#for msgIndex in _pageBreakdown[_currentPage]._messages:
		#var levelSetup : LevelSetup = messageLibrary.Levels[msgIndex]
		#if levelSetup.message.length() < smallMessageThreshold:
			#match currentSize:
				#0:
					#topLeftSmallMsgBox.get_parent()
					#pass
				#1:
					#pass
				#2:
					#pass
				#3:
					#pass
		#else:
			#pass
	pass

func PrevPage():
	if _currentPage == 0:
		_currentPage = _pageBreakdown.size() - 1
	else:
		_currentPage -= 1
	myScreen.screenManager.ShowTransitionAnimation(ScreenManager.TransitionStyle.BACK_PAGE, LoadPage, _AnimFinished)

func NextPage():
	if _currentPage + 1 == _pageBreakdown.size():
		_currentPage = 0
	else:
		_currentPage += 1
	myScreen.screenManager.ShowTransitionAnimation(ScreenManager.TransitionStyle.TURN_PAGE, LoadPage, _AnimFinished)

func on_back_clicked():
	myScreen.GoToScreen(load("res://MainScenes/main_menu.tscn"), {}, ScreenManager.TransitionStyle.BACK_PAGE)


func _AnimFinished():
	#print_debug("animation finished call")
	pass

func _ready():
	var currentIndex = 0
	_pageBreakdown = []
	_pageBreakdown.push_back(MessagePageHandler.new())
	
	#run through the messaes library in order
	for levelSetup in messageLibrary.Levels:
		#determine the sizes of each based on the number of characters
		if levelSetup.message.length() < smallMessageThreshold:
			var messagePlaced : bool = false
			
			#check if there is space on an earlier page
			for potentialPage in _pageBreakdown:
				if potentialPage.AddMessage(currentIndex, 1):
					messagePlaced = true
					break
			
			#must make new page
			if messagePlaced == false:
				_pageBreakdown.push_back(MessagePageHandler.new())
				_pageBreakdown.back().AddMessage(currentIndex, 1)
		else:
			#will only potentially fit on the last page
			if _pageBreakdown.back().AddMessage(currentIndex, 2) == false:
				_pageBreakdown.push_back(MessagePageHandler.new())
				_pageBreakdown.back().AddMessage(currentIndex, 2)
		
		currentIndex += 1
	
	_currentPage = 0
	LoadPage()
