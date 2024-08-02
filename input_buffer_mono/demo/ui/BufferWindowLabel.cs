using Godot;
using System;

public partial class BufferWindowLabel : Label
{
	public override void _Ready() {
		SetText();
	}

	public override void _Process(double delta) {
		SetText();
	}

	private void SetText() {
		if (GameManager.UseBufferedInput) {
			Text = $"Buffer Window: {BufferedInput.BufferWindow}ms";
		} else {
			Text = $"Buffer Window: 0ms";
		}
	}
}
