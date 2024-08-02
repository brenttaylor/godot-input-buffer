extends Area2D

@export var speed: float = 100.0

func _process(delta: float) -> void:
	position = Vector2(position.x - (speed * delta), position.y)

func restart_game() -> void:
	get_tree().reload_current_scene()

func on_screen_exited() -> void:
	if global_position.x < 0:
		queue_free()

func on_body_entered(body: Node2D) -> void:
	if body is Player:
		AudioBus.play_player_collision();
		GameManager.player_death()