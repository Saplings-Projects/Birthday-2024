class_name MessageGallery
extends Control

const LARGE_MESSAGE_SIZE : int = 2
const SMALL_MESSAGE_SIZE : int = 1
const AUTHOR_PREFIX : String = "-"

@export var smallMessageThreshold : int = 250
@export var myScreen : ScreenLogic
@export var messageLibrary : LevelLibrary
@export var pageNumberText : Label

@export var topLeftSmallMsgBox : MessageEmoteInserter
@export var topLeftAuthorText : Label
@export var bottomLeftSmallMsgBox : MessageEmoteInserter
@export var bottomLeftAuthorText : Label
@export var leftBigMsgBox : MessageEmoteInserter
@export var leftAuthorText : Label
@export var topRightSmallMsgBox : MessageEmoteInserter
@export var topRightAuthorText : Label
@export var bottomRightSmallMsgBox : MessageEmoteInserter
@export var bottomRightAuthorText : Label
@export var rightBigMsgBox : MessageEmoteInserter
@export var rightAuthorText : Label

var _currentPage : int
var _pageBreakdown : Array[MessagePageHandler]

func LoadPage():
	var availableBoxes : Array[bool] = [true, true, true, true]
	pageNumberText.text = str(_currentPage + 1, "/", _pageBreakdown.size())
	
	for msgIndex in _pageBreakdown[_currentPage]._messages:
		var levelSetup : LevelSetup = messageLibrary.Levels[msgIndex]
		if levelSetup.message.length() < smallMessageThreshold:
			var boxIndex : int = 0
			for availableBox in availableBoxes:
				if availableBox:
					break
				else:
					boxIndex += 1
			
			availableBoxes[boxIndex] = false
			match boxIndex:
				0:
					(topLeftSmallMsgBox.get_parent() as Control).visible = true
					(leftBigMsgBox.get_parent() as Control).visible = false
					
					topLeftSmallMsgBox.text = levelSetup.message
					topLeftSmallMsgBox.SwapTokens()
					topLeftAuthorText.text = str(AUTHOR_PREFIX, levelSetup.author)
				1:
					(bottomLeftSmallMsgBox.get_parent() as Control).visible = true
					
					bottomLeftSmallMsgBox.text = levelSetup.message
					bottomLeftSmallMsgBox.SwapTokens()
					bottomLeftAuthorText.text = str(AUTHOR_PREFIX, levelSetup.author)
				2:
					(topRightSmallMsgBox.get_parent() as Control).visible = true
					(rightBigMsgBox.get_parent() as Control).visible = false
					
					topRightSmallMsgBox.text = levelSetup.message
					topRightSmallMsgBox.SwapTokens()
					topRightAuthorText.text = str(AUTHOR_PREFIX, levelSetup.author)
				3:
					(bottomRightSmallMsgBox.get_parent() as Control).visible = true
					
					bottomRightSmallMsgBox.text = levelSetup.message
					bottomRightSmallMsgBox.SwapTokens()
					bottomRightAuthorText.text = str(AUTHOR_PREFIX, levelSetup.author)
		else:
			if availableBoxes[0]:
				#left side
				availableBoxes[0] = false
				availableBoxes[1] = false
				
				(topLeftSmallMsgBox.get_parent() as Control).visible = false
				(bottomLeftSmallMsgBox.get_parent() as Control).visible = false
				(leftBigMsgBox.get_parent() as Control).visible = true
				
				leftBigMsgBox.text = levelSetup.message
				leftBigMsgBox.SwapTokens()
				leftAuthorText.text = str(AUTHOR_PREFIX, levelSetup.author)
			else:
				#right side
				availableBoxes[2] = false
				availableBoxes[3] = false
				
				(topRightSmallMsgBox.get_parent() as Control).visible = false
				(bottomRightSmallMsgBox.get_parent() as Control).visible = false
				(rightBigMsgBox.get_parent() as Control).visible = true
				
				rightBigMsgBox.text = levelSetup.message
				rightBigMsgBox.SwapTokens()
				rightAuthorText.text = str(AUTHOR_PREFIX, levelSetup.author)
	
	#cleanup unused
	if availableBoxes[0]:
		(topLeftSmallMsgBox.get_parent() as Control).visible = false
		(leftBigMsgBox.get_parent() as Control).visible = false
	
	if availableBoxes[1]:
		(bottomLeftSmallMsgBox.get_parent() as Control).visible = false
		
	if availableBoxes[2]:
		(topRightSmallMsgBox.get_parent() as Control).visible = false
		(rightBigMsgBox.get_parent() as Control).visible = false
		
	if availableBoxes[3]:
		(bottomRightSmallMsgBox.get_parent() as Control).visible = false

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
			#big msg will only potentially fit on the last page
			if _pageBreakdown.back().AddMessage(currentIndex, 2) == false:
				#make a new page
				_pageBreakdown.push_back(MessagePageHandler.new())
				_pageBreakdown.back().AddMessage(currentIndex, 2)
		
		currentIndex += 1
	
	_currentPage = 0
	LoadPage()
