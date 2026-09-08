extends CharacterBody2D
var pos:Vector2
var rota:float
var dir := 0.0
var speed = 50000

func _ready():
		global_position = pos
		global_rotation = rota
	
func _physics_process(_delta):
	velocity = Vector2(speed,0).rotated(dir)*(_delta)


	move_and_slide()
