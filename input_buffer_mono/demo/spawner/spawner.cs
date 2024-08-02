using Godot;
using System;

public partial class spawner : Marker2D
{
	[Export] public PackedScene Enemy;
	[Export] public float MinimumSpawnDelay = 0.5f;
	[Export] public float MaximumSpawnDelay = 5.0f;

	private Timer _spawnTimer;
	private Timer _gameTimer;

	public override void _Ready() {
		_spawnTimer = GetNode<Timer>("SpawnTimer");
		SetTimer();
	}

	private void SetTimer() {
		_spawnTimer.WaitTime = GD.RandRange(MinimumSpawnDelay, MaximumSpawnDelay);
		_spawnTimer.Start();
	}

	public void OnSpawnTimerTimeout() {
		var enemy = (Node2D) Enemy.Instantiate();
		AddChild(enemy);
		enemy.GlobalPosition = GlobalPosition;
		SetTimer();
	}

	public void OnGameTimerTimeout() {
		MaximumSpawnDelay = Math.Max(MaximumSpawnDelay - 0.05f, 2.5f);
	}
}
