using Godot;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Reflection.Metadata.Ecma335;

/// <summary>
/// Keeps track of recent inputs in order to make timing windows more flexible.
/// Intended use: Add this file to your project as an AutoLoad script and have other objects call the class' static 
/// methods.
/// (more on AutoLoad: https://docs.godotengine.org/en/stable/tutorials/scripting/singletons_autoload.html)
/// </summary>
public partial class BufferedInput : Node {
    protected abstract class InputEventTimestamps<EventType,KeyType> {
        protected Dictionary<KeyType, ulong> _timestamps = new Dictionary<KeyType, ulong>();

        protected abstract bool CanAddTimestamp(EventType @event);
        protected abstract KeyType GetKey(EventType @event);

        public void AddTimestamp(EventType @event) {
            if (CanAddTimestamp(@event)) {
                _timestamps[GetKey(@event)] = Time.GetTicksMsec();
            }
        }

        public bool IsEventBuffered(EventType @event, int buffer) {
            var key = GetKey(@event);
            if (_timestamps.ContainsKey(key)) {
                var delta = Time.GetTicksMsec() - _timestamps[key];
                if (delta <= (ulong) buffer) {
                    _timestamps[key] = 0; //Invalidate the input so it doesn't return true again
                    return true;
                }
            }
            return false;
        }
    }

    protected class InputEventKeyTimestamps: InputEventTimestamps<InputEventKey, Key> {
        protected override Key GetKey(InputEventKey @event) => @event.PhysicalKeycode;
        protected override bool CanAddTimestamp(InputEventKey @event) => @event.IsPressed() && !@event.IsEcho();
    }

    protected class InputEventJoypadButtonTimestamps: InputEventTimestamps<InputEventJoypadButton, int> {
        protected override int GetKey(InputEventJoypadButton @event) => (int) @event.ButtonIndex;
        protected override bool CanAddTimestamp(InputEventJoypadButton @event) => @event.IsPressed() && !@event.IsEcho();
    }

    protected class InputEventMouseButtonTimestamps: InputEventTimestamps<InputEventMouseButton, int> {
        protected override int GetKey(InputEventMouseButton @event) => (int) @event.ButtonIndex;
        protected override bool CanAddTimestamp(InputEventMouseButton @event) => @event.IsPressed() && !@event.IsEcho();
    }

    /// <summary>
    /// How many milliseconds ahead of time the player can make an input and have it still be recognized.
    /// I chose the value 150 because it imitates the 9-frame buffer window in the Super Smash Bros. Ultimate game.
    /// </summary>
    private static ulong BUFFER_WINDOW = 150;
    public static ulong BufferWindow { get => BUFFER_WINDOW; set => BUFFER_WINDOW = value; }

    private static InputEventKeyTimestamps _inputEventKeyTimestamps = new InputEventKeyTimestamps();
    private static InputEventJoypadButtonTimestamps _inputEventJoypadButtonTimestamps = new InputEventJoypadButtonTimestamps();
    private static InputEventMouseButtonTimestamps _inputEventMouseButtonTimestamps = new InputEventMouseButtonTimestamps();

    /// <summary>
    /// Singleton instance of the InputBuffer.
    /// </summary>
    private static BufferedInput _instance = null;

    /// <summary>
    /// Called when the node enters the scene tree for the first time.
    /// </summary>
    public override void _Ready()
    {
        ProcessMode = ProcessModeEnum.Always;
        _instance = this;
    }

    /// <summary>
    /// Called whenever there is an input event in the input queue.
    /// </summary>
    /// <param name="@event"> Object containing information about the input. </param>
    public override void _Input(InputEvent @event)
    {
        switch (@event) {
            case InputEventKey eventKey:
                _inputEventKeyTimestamps.AddTimestamp(eventKey);                        break;
            case InputEventJoypadButton eventJoypadButton:
                _inputEventJoypadButtonTimestamps.AddTimestamp(eventJoypadButton);      break;
            case InputEventMouseButton eventMouseButton:
                _inputEventMouseButtonTimestamps.AddTimestamp(eventMouseButton);        break;
            default:                                                    break;
        }
    }

    /// <summary>
    /// Returns whether any of the keyboard keys or joypad buttons in the given action were pressed within the buffer 
    /// window.
    /// </summary>
    /// <param name="action"> The action to check for in the buffer. </param>
    /// <param name="buffer"> How many milliseconds ahead of time the player can make an input and have it still be recognized.</param>
    /// <returns>
    /// True if any of the action's associated keys/buttons were pressed within the buffer window, false otherwise. 
    /// </returns>
    public static bool IsActionJustPressed(string action, int buffer = -1)
    {
        // First check to make sure this node exists in the scene tree and add it if it isn't.
        if (_instance == null) {
            var sceneTree = Engine.GetMainLoop() as SceneTree;
            BufferedInput bufferedInput = new BufferedInput();
            bufferedInput.Name = "BufferedInput";
            sceneTree.Root.AddChild(bufferedInput);
            GD.PrintErr("BufferedInput was not autoloaded.  No wloaded, but first input was eaten.");
            return false;
        }

        // We allow the user to set a specific buffer on a per action basis
        if (buffer == -1) buffer = (int)BUFFER_WINDOW;

        // Because it's possible for an action to have multiple inputs, we have to check all of them
        // otherwise if multiple inputs are pressed at once, "IsActionJustPressed" will return true
        // multiple times.
        var results = new List<bool>();
        foreach (InputEvent @event in InputMap.ActionGetEvents(action)) {
            if (@event is InputEventKey eventKey) results.Add(_inputEventKeyTimestamps.IsEventBuffered(eventKey, buffer));
            if (@event is InputEventMouseButton eventMouseButton) results.Add(_inputEventMouseButtonTimestamps.IsEventBuffered(eventMouseButton, buffer));
            if (@event is InputEventJoypadButton eventJoypadButton) results.Add(_inputEventJoypadButtonTimestamps.IsEventBuffered(eventJoypadButton, buffer));
        }

        return results.Any(result => result == true);
    }
}