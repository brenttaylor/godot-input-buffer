extends Node

@onready var player_jump: AudioStreamPlayer2D = $PlayerJump
@onready var player_collision: AudioStreamPlayer2D = $PlayerCollision
@onready var ui_click: AudioStreamPlayer2D = $UIClick

func play_player_jump() -> void:
	player_jump.play()

func play_player_collision() -> void:
	player_collision.play()

func play_ui_click() -> void:
	ui_click.play()