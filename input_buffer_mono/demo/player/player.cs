using Godot;
using System;
using System.Runtime.CompilerServices;

public partial class player : CharacterBody2D {
	[Export]
	public float JumpVelocity = -300.0f;

	// Get the gravity from the project settings to be synced with RigidBody nodes.
	public float gravity = ProjectSettings.GetSetting("physics/2d/default_gravity").AsSingle();

    public override void _PhysicsProcess(double delta)
	{
		Vector2 velocity = Velocity;

		// Add the gravity.
		if (!IsOnFloor()) {
			velocity.Y += gravity * (float)delta;
		}

		if (IsOnFloor()) {
			if (GameManager.UseBufferedInput && BufferedInput.IsActionJustPressed("jump")) {
				velocity.Y = JumpVelocity;
				AudioBus.PlayPlayerJump();
			} else if (Input.IsActionJustPressed("jump")) {
				velocity.Y = JumpVelocity;
				AudioBus.PlayPlayerJump();
			}
		}

		Velocity = velocity;
		MoveAndSlide();
	}
}
