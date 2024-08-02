using Godot;
using System;

public partial class enemy : Area2D {
	[Export] public float Speed = 100.0f;

	public override void _Process(double delta) {
		Position = new Vector2(Position.X - (Speed * (float) delta), Position.Y);
	}

	private void RestartGame() {
		GetTree().ReloadCurrentScene();
	}

	public void OnScreenExited() {
		if (Position.X < 0) {
			QueueFree();
		}
	}

	public void OnBodyEntered(Node2D body) {
		if (body is player player) {
			AudioBus.PlayPlayerCollision();
			GameManager.PlayerDeath();
		}
	}
}
