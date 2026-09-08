extends Control

@export var game_scene:PackedScene


var player_name: Array[String] = ["", "", "", ""]


func _physics_process(_delta):
	print(player_name)



@onready var edits := [
	$ColorRect/LineEdit,
	$ColorRect/LineEdit2,
	$ColorRect/LineEdit3,
	$ColorRect/LineEdit4
]

func change_scene():
	for i in range(4):
		player_name[i] = edits[i].text.strip_edges()

	var game = game_scene.instantiate()
	game.call("set_player_names", player_name)

	var old = get_tree().current_scene
	get_tree().root.add_child(game)
	get_tree().current_scene = game
	old.queue_free()




func player1(new_text: String) -> void:
	player_name[0] = new_text


func player2(new_text: String) -> void:
	player_name[1] = new_text


func player3(new_text: String) -> void:
	player_name[2] = new_text


func player4(new_text: String) -> void:
	player_name[3] = new_text
