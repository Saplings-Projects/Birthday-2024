class_name GridSpaceStatusEnum

enum GridSpaceStatus {
	OPEN,
	OCCUPIED,
	CLOSED #blocked or unused
}

static var IntToEnumDict : Dictionary = {}

static func IntToEnum(key : int) -> GridSpaceStatus:
	if IntToEnumDict.size() == 0:
		for enumName in GridSpaceStatus:
			IntToEnumDict[enumName as int] = enumName
	return IntToEnumDict[key]
