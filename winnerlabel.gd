extends Control
@onready var winner_label: Label = $WinnerLabel

func set_winner_text(t: String) -> void:
	winner_label.text = t
