class_name MessagePageHandler

const MAX_SIZE : int = 4

var _currentSize : int = 0
var _messages : Array[int] = []

func IsFull() -> bool:
	return _currentSize == MAX_SIZE

func CanFit(size : int) -> bool:
	return _currentSize + size <= MAX_SIZE
	
func AddMessage(msgIndex : int, msgSize : int) -> bool:
	if CanFit(msgSize):
		_messages.push_back(msgIndex)
		_currentSize += msgSize
		return true
	else:
		return false
