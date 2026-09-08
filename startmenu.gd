extends Control

@export var player_setup:PackedScene


func _on_start_pressed():
	get_tree().change_scene_to_packed(player_setup)


func _on_quit_pressed():
	get_tree().quit()
