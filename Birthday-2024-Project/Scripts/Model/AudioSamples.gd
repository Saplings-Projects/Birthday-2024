class_name AudioSamples
extends Resource


@export var samples: Array[AudioStream] = []


func get_random_sample() -> AudioStream:
	if samples.size() == 0:
		return null
	
	return samples.pick_random()

