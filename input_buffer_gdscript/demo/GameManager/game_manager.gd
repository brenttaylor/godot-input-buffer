extends Node

@onready var _animation_player: AnimationPlayer = $AnimationPlayer

var _buffer_adjustment: int = 10
var use_buffered_input: bool = true

func _process(_delta: float) -> void:
	if Input.is_action_just_pressed("quit"):
		AudioBus.play_ui_click()
		get_tree().quit()
	
	if Input.is_action_just_pressed("swap_input"):
		use_buffered_input = !use_buffered_input
		AudioBus.play_ui_click()

	# Adjust the buffer window
	if Input.is_action_just_pressed("ui_up"):
		BufferedInput.BufferWindow += _buffer_adjustment

	if Input.is_action_just_pressed("ui_down"):
		BufferedInput.BufferWindow -= _buffer_adjustment	
	
func player_death() -> void:
	_animation_player.play("FadeOut")

func on_animation_finished(animation_name: StringName) -> void:
	if animation_name == "FadeOut":
		get_tree().reload_current_scene()
		_animation_player.play("FadeIn")
