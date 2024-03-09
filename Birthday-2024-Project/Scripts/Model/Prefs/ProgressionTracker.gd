extends Preferences
class_name ProgressionTracker

const _SECTION_NAME: String = "PROGRESS"
const CAMPAIGN_KEY : String = "CAMPAIGN"
const SAPLINGS_KEY : String = "SAPLINGS"

var _gm: GameMaster
var _campaignProgress : int
var _levelCompletionDictionary : Dictionary

func GetLastCampaignLevelCompleted() -> int:
	return _campaignProgress

func SetLatestCampaignLevelCompleted(levelCompleted : int):
	if levelCompleted > _campaignProgress:
		_campaignProgress = levelCompleted
		_gm.save_preferences()

func IsLevelCompleted(levelName : String) -> bool:
	return _levelCompletionDictionary.has(levelName) and _levelCompletionDictionary[levelName] == true

func MarkLevelCompleted(levelName : String, setTrue : bool = true):
	_levelCompletionDictionary[levelName] = setTrue
	_gm.save_preferences()

func _apply_config(config: ConfigFile):
	if not config.has_section(_SECTION_NAME):
		_apply_defaults()
		return
	
	_campaignProgress = config.get_value(_SECTION_NAME, CAMPAIGN_KEY, -1)
	var jsonDictionary : String = config.get_value(_SECTION_NAME, SAPLINGS_KEY, "")
	if jsonDictionary == "":
		_levelCompletionDictionary = {}
		return
		
	var json = JSON.new()
	var error = json.parse(jsonDictionary)
	if(error == OK):
		_levelCompletionDictionary = json.data
	else:
		_levelCompletionDictionary = {}
		printerr("ERROR: Unable to parse level progress data")

func _apply_defaults():
	_campaignProgress = -1
	_levelCompletionDictionary = {}

func _init(config: ConfigFile = null):	
	if config == null:
		_apply_defaults()
	else:
		_apply_config(config)

func _save_config(config: ConfigFile):
	config.set_value(_SECTION_NAME, CAMPAIGN_KEY, _campaignProgress)
	config.set_value(_SECTION_NAME, SAPLINGS_KEY, JSON.stringify(_levelCompletionDictionary))
