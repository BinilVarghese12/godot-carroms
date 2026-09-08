extends Control




@onready var name1: LineEdit = $VBoxContainer/LineEdit
@onready var name2: LineEdit = $VBoxContainer/LineEdit1
@onready var name3: LineEdit = $VBoxContainer/LineEdit2
@onready var name4: LineEdit = $VBoxContainer/LineEdit3

var player_names = ["","","",""]


func _clean(t: String, idx: int) -> String:
	t = t.strip_edges()
	return t if t != "" else "Player %d" % idx


func _on_start_pressed() -> void:
	player_names[0] = _clean(name1.text, 1)
	player_names[1] = _clean(name2.text, 2)
	player_names[2] = _clean(name3.text, 3)
	player_names[3] = _clean(name4.text, 4)


	get_tree().change_scene_to_file("res://game.tscn")
