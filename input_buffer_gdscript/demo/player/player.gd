extends CharacterBody2D

class_name Player

@export var jump_velocity: float = 300.0

# Get the gravity from the project settings to be synced with RigidBody nodes.
var gravity = ProjectSettings.get_setting("physics/2d/default_gravity")

func _physics_process(delta):
	# Add the gravity.
	if not is_on_floor():
		velocity.y += gravity * delta

	# Handle jump.
	if (is_on_floor()):
		if GameManager.use_buffered_input && BufferedInput.is_action_just_pressed("jump"):
			velocity.y = -jump_velocity
			AudioBus.play_player_jump()
		elif Input.is_action_just_pressed("jump"):
			velocity.y = -jump_velocity
			AudioBus.play_player_jump()

	move_and_slide()
