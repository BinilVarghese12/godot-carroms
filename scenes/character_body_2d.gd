extends CharacterBody2D

@export var bullet_scene:PackedScene

func _physics_process(_delta):
	if Input.is_action_just_pressed("ui_accept"):
		print("fired")
		fire()

func fire():
	var bullet = bullet_scene.instantiate()
	bullet.global_position = global_position
	bullet.global_rotation = global_rotation
	get_parent().add_child(bullet)
