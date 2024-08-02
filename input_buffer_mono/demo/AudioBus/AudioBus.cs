using Godot;
using System;

public partial class AudioBus : Node {
	private static AudioBus _instance = null;

    public override void _Ready() {
		_instance = this;
    }

	public static void PlayPlayerJump() {
		var playerJump = _instance.GetNode<AudioStreamPlayer2D>("PlayerJump");
		playerJump.Play();
	}

    public static void PlayPlayerCollision() {
		var playerCollision = _instance.GetNode<AudioStreamPlayer2D>("PlayerCollision");
		playerCollision.Play();
	}

	public static void PlayUIClick() {
		var uiClick = _instance.GetNode<AudioStreamPlayer2D>("UIClick");
		uiClick.Play();
	}
}
