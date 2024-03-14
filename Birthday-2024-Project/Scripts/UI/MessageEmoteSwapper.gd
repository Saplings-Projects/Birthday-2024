class_name MessageEmoteInserter
extends RichTextLabel

const IMG_PREFIX : String = "[img]"
const IMG_SUFFIX : String = "[/img]"

var _tokenToImageDict : TokenToImageDict

func _ready():
	_tokenToImageDict = load("res://Resources/TokenEmoteDictionary.tres")
	SwapTokens()

func SwapTokens():
	text = _SwapTokens(text)

func _SwapTokens(message : String) -> String:
	for pair in _tokenToImageDict.tokenData:
		message = message.replace(pair.token, IMG_PREFIX + pair.image.resource_path + IMG_SUFFIX)
	return message
