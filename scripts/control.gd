extends Control

@export var game_scene:PackedScene
var friction_preview := true
var aim_line_preview := true

var previous_scene: Node2D = null






func _on_friction_toggled(toggled_on: bool) -> void:
	friction_preview = toggled_on

func _on_button_pressed() -> void:
	previous_scene.visible = true
	get_tree().current_scene = previous_scene
	queue_free()




func _on_button_2_pressed() -> void:
	get_tree().quit()

func _on_apply_pressed() -> void:
	previous_scene.friction_enabled = friction_preview
	previous_scene.apply_friction_settings()
	previous_scene.aim_line_enabled = aim_line_preview
	previous_scene.apply_aim_line_settings()
