extends Label

func _ready() -> void:
	set_label_text()

func _process(_delta: float) -> void:
	set_label_text()

func set_label_text() -> void:
	if GameManager.use_buffered_input:
		text = "Buffer Window: " + str(BufferedInput.BufferWindow)
	else:
		text = "Buffer Window: 0ms"