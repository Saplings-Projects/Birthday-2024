class_name RotationEnum

enum Rotation { 
	NONE,
	CLOCKWISE90,
	FLIPPED180,
	COUNTERWISE90
}

static var IntToEnumDict = null

static func IntToEnum(key : int):
	if IntToEnumDict == null:
		IntToEnumDict = Dictionary()
		for enumName in Rotation:
			IntToEnumDict[enumName as int] = enumName
	return IntToEnumDict[key]
