extends Node2D

@export var carrom : PackedScene
@export var striker : PackedScene
var current_striker: Node2D = null
var count_c := 0
var carrom_potted : bool
var potted:= []


 #2d array storing all of the coordinates for them to spawned in whne the game starts

const c_positions := [[-65,65,0,0,-32.5,-32.5,32.5,32.5],[0,0,65,-65,32.5,-32.5,32.5,-32.5]]
const c_positions_white := [[0,0,32.5,-32.5],[32.5,-32.5,0,0]]
#creating the striker mechanic

const carrom_spawn_pos = [[0,0,218,-218],[210,-210,0,0],[0,0,0,0]]
#the first array store the x spawn positikon,the second stores the coresponding y spawn positions and the 
#thrid array will store the scores of each of the

var start_pos := Vector2(218,0)
	
	
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	$"."/board/pockets.body_entered.connect(pocketed_carrom)
	new_game()
#This for whne you start the game you want the carroms to be 
#generated in the correct lcoations,as thye have a set layout
 #instead of creating an individual scene for each ball,which is long and tedious we are goin instantiate it 
 #multiple time such that it always starts in the correct positions.
func new_game():
	generate_carroms()
	
func generate_carroms():
		for x in range(8):
			var x_pos = c_positions[0][x]
			var y_pos = c_positions[1][x]
			var b = carrom.instantiate()
			var pos = Vector2(x_pos,y_pos)
			add_child(b)
			b.position = pos
			b.get_node("Sprite2D").texture = load("res://assets/placeholder.png")
		for y in range(4):
			var x_pos1 = c_positions_white[0][y]
			var y_pos1 = c_positions_white[1][y]
			var c = carrom.instantiate()
			var pos2 = Vector2(x_pos1,y_pos1)
			add_child(c)
			c.position = pos2
			c.get_node("Sprite2D").texture = load("res://assets/placeholder_white.png")
		var d = carrom.instantiate()
		var pos3 = Vector2(0,0)
		add_child(d)
		d.position = pos3
		d.get_node("Sprite2D").texture = load("res://assets/placeholder_red.png")
		


func _physics_process(_delta):
	if Input.is_action_just_pressed("ui_accept"):
		print("fired")
		fire()

		
	
		
func fire():
	count_c += 1
	if count_c == 4:
		count_c = 0	
	if current_striker != null:
		current_striker.queue_free()

	current_striker = striker.instantiate()
	add_child(current_striker)
	


	var x_pos_c = carrom_spawn_pos[0][count_c]
	var y_pos_c = carrom_spawn_pos[1][count_c]
	start_pos=Vector2(x_pos_c,y_pos_c)
	current_striker.global_position = start_pos
	current_striker.call_deferred("shoot_towards", get_global_mouse_position())

func pocketed_carrom(body):
	print("carrom potted")
	carrom.hide()

	
	


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta: float) -> void:
	pass
