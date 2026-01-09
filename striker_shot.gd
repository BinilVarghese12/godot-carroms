extends CharacterBody2D
var pos:Vector2
var rota_object:float
var dir:float
var speed =200

func _ready():
	global_position = pos
	global_rotation = rota_object


func _physics_process(delta):
	velocity = (Vector2(speed,0).rotated(dir))
	move_and_slide()
