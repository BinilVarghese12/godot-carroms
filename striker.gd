extends RigidBody2D

@export var speed := 500
var can_shoot := true

func _physics_process(_delta: float) -> void:
	if not can_shoot:
		return

	if Input.is_action_just_pressed("ui_accept"):
		shoot_towards(get_global_mouse_position())
	speed = speed * 0.8

func shoot_towards(target: Vector2) -> void:
	can_shoot = false
	var dir := (target - global_position).normalized()
	apply_impulse(dir * speed)
