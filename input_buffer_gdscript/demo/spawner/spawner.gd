extends Marker2D

@export var enemy: PackedScene
@export var minimum_spawn_delay: float = 0.5
@export var maximum_spawn_delay: float = 5.0

@onready var _spawn_timer: Timer = $SpawnTimer

func _ready() -> void:
	set_timer()

func set_timer() -> void:
	_spawn_timer.wait_time = randf_range(minimum_spawn_delay, maximum_spawn_delay)
	_spawn_timer.start()

func on_spawn_timer_timeout() -> void:
	var new_enemy: Node2D = enemy.instantiate()
	add_child(new_enemy)
	new_enemy.global_position = global_position
	set_timer()

func on_game_timer_timeout() -> void:
	maximum_spawn_delay = maxf(maximum_spawn_delay - 0.05, 2.5)