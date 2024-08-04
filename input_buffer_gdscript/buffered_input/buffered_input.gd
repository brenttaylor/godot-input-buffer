extends Node
# Keeps track of recent inputs in order to make timing windows more flexible.
# Intended use: Add this file to your project as an Autoload script and have other objects call the class' methods.
# (more on AutoLoad: https://docs.godotengine.org/en/stable/tutorials/scripting/singletons_autoload.html)

# How many milliseconds ahead of time the player can make an input and have it still be recognized.
# I chose the value 150 because it imitates the 9-frame buffer window in the Super Smash Bros. Ultimate game.
var BufferWindow: int = 150 :
	get:
		return BufferWindow
	set(value):
		BufferWindow = max(0, value)

class InputEventTimestamps:
	var _timestamps: Dictionary = {}

	# Override get_key
	@warning_ignore("unused_parameter")
	func get_key(event: InputEvent) -> Variant:
		return null
	
	# Override this as necessary
	func can_add_timestamp(event: InputEvent) -> bool:
		return event.is_pressed() && !event.is_echo()
	
	func add_timestamp(event: InputEvent) -> void:
		if can_add_timestamp(event):
			_timestamps[get_key(event)] = Time.get_ticks_msec()
	
	func is_event_buffered(event: InputEvent, buffer: int) -> bool:
		var key: Variant = get_key(event)
		if _timestamps.has(key):
			var delta: float = Time.get_ticks_msec() - _timestamps[key]

			if delta <= buffer:
				_timestamps[key] = 0
				return true
		return false

class InputEventKeyTimestamps extends InputEventTimestamps:
	func get_key(event: InputEvent) -> Variant:
		return (event as InputEventKey).physical_keycode

class InputEventMouseButtonTimestamps extends InputEventTimestamps:
	func get_key(event: InputEvent) -> Variant:
		return (event as InputEventMouseButton).button_index
	
class InputEventJoypadButtonTimestamps extends InputEventTimestamps:
	func get_key(event: InputEvent) -> Variant:
		return (event as InputEventJoypadButton).button_index

var _inputEventKeyTimestamps := InputEventKeyTimestamps.new()
var _inputEventMouseButtonTimestamps := InputEventMouseButtonTimestamps.new()
var _inputEventJoypadButtonTimestamps := InputEventJoypadButtonTimestamps.new()

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	process_mode = Node.PROCESS_MODE_PAUSABLE
	
# Called whenever the player makes an input.
func _input(event: InputEvent) -> void:
	match event.get_class():
		"InputEventKey":          _inputEventKeyTimestamps.add_timestamp(event)
		"InputEventMouseButton":  _inputEventMouseButtonTimestamps.add_timestamp(event)
		"InputEventJoypadButton": _inputEventJoypadButtonTimestamps.add_timestamp(event)

func is_action_just_pressed(action: String, buffer: int = -1) -> bool:
	var bwindow := BufferWindow if buffer == -1 else buffer
	var results: Array = []

	for event in InputMap.action_get_events(action):
		match event.get_class():
			"InputEventKey":          results.append(_inputEventKeyTimestamps.is_event_buffered(event, bwindow))
			"InputEventMouseButton":  results.append(_inputEventMouseButtonTimestamps.is_event_buffered(event, bwindow))
			"InputEventJoypadButton": results.append(_inputEventJoypadButtonTimestamps.is_event_buffered(event, bwindow))
	return results.any(func(result: bool) -> bool: return result)
