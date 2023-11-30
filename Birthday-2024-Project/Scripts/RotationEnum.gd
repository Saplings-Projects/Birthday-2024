class_name RotationEnum

enum Rotation { 
	NONE,
	CLOCKWISE90,
	FLIPPED180,
	COUNTERWISE90
}

static var IntToEnumDict : Dictionary = {}

static func IntToEnum(key : int) -> Rotation:
	if IntToEnumDict.size() == 0:
		for enumName in Rotation:
			IntToEnumDict[enumName as int] = enumName
	return IntToEnumDict[key]
