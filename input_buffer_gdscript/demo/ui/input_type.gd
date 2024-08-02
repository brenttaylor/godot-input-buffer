extends Label

func _ready() -> void:
	set_label_text()

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta: float) -> void:
	set_label_text()

func set_label_text() -> void:
	if GameManager.use_buffered_input:
		text = "Input: Buffered"
	else:
		text = "Input: Unbuffered"