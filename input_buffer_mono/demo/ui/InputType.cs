using Godot;
using System;

public partial class InputType : Label
{
	public override void _Ready() {
		SetText();
	}

	public override void _Process(double delta) {
		SetText();
	}

	private void SetText() {
		if (GameManager.UseBufferedInput) {
			Text = "Input: Buffered";
		} else {
			Text = "Input: Unbuffered";
		}
	}
}
