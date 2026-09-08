extends RigidBody2D

@export var speed := 2000
var can_shoot := true

func _physics_process(_delta: float) -> void:
	pass
	

func shoot_towards(target: Vector2, power: float) :
	can_shoot = false
	var dir := (global_position - target).normalized()
	linear_velocity = dir * power *5
