using Godot;
using System;

public partial class GameManager : Node
{
	private static GameManager _instance = null;
	private static uint _bufferAdjustment = 10;


	private static bool _useBufferedInput = true;
	public static bool UseBufferedInput { get => _useBufferedInput; }

	private AnimationPlayer _animationPlayer = null;

	public override void _Ready() {
		_instance = this;
		_animationPlayer = GetNode<AnimationPlayer>("AnimationPlayer");
	}

	public override void _Process(double delta) {
		if (Input.IsActionJustPressed("quit")) {
			AudioBus.PlayUIClick();
			GetTree().Quit();
		}

		if (Input.IsActionJustPressed("swap_input")) {
			_useBufferedInput = !_useBufferedInput;
			AudioBus.PlayUIClick();
		}

		// Adjust the buffer window
		if (Input.IsActionJustPressed("ui_up")) {
			BufferedInput.BufferWindow += _bufferAdjustment;
			AudioBus.PlayUIClick();
		}
		if (Input.IsActionJustPressed("ui_down")) {
			BufferedInput.BufferWindow -= _bufferAdjustment;
			AudioBus.PlayUIClick();
		}
	}

	public static void PlayerDeath() {
		_instance._animationPlayer.Play("FadeOut");
	}

	public void OnAnimationFinished(StringName name) {
		if (name.ToString() == "FadeOut") {
			GetTree().ReloadCurrentScene();
			_animationPlayer.Play("FadeIn");	
		}
	}
}
