extends Node2D


@export var carrom : PackedScene
@export var striker : PackedScene
@export_file("*.tscn") var start_scene_path := "res://startmenunew.tscn"
@export var settings_scene :PackedScene
@onready var score_label: Label = $CanvasLayer/ScoreLabel
@onready  var aim_line: Line2D = $"aim line"
var current_striker: Node2D = null
var count_c := 0
var carrom_potted : bool
var potted:= []
const black_score := 1
const white_score := 1
const red_score := 5
const carrom_score  := -2
var shot_taken := false
const max_aim_length := 100
var current_power := 0.0
@export var stop_speed := 50
var can_shoot := true
@export var  striker_slide_velocity := 200
@export var min_x := -200
@export var max_x := 200
var aim_line_enabled := true
@export var min_y := -200
@export var max_y := 200
var count_striker_boundary := 0
var placing_striker := true
@export var winner_scene: PackedScene
var game_over := false
var max_score := 0
var max_index := 0
var previous_scene: Node2D




const striker_boundaries = [
	[-160, 160,  210,  210],
	[-160, 160, -210, -210],
	[ 218, 218, -160,  160],
	[-218,-218, -160,  160]
]

#2d array storing all of the coordinates for them to spawned in whne the game starts

const c_positions := [[-65,65,0,0,-32.5,-32.5,32.5,32.5],[0,0,65,-65,32.5,-32.5,32.5,-32.5]]
const c_positions_white := [[0,0,32.5,-32.5],[32.5,-32.5,0,0]]
#creating the striker mechanic

var carrom_spawn_pos = [[0,0,218,-218],[210,-210,0,0],[0,0,0,0]]
#the first array store the x spawn positikon,the second stores the coresponding y spawn positions and the 
#thrid array will store the scores of each of the

var start_pos := Vector2(218,0)
#stores the starting position where the striker will spawn from 

var friction_enabled := true
#used for the toggle to turn friction on and off
var player_names: Array[String] = []
#stores the values passed in by the player setup scene

func set_player_names(names: Array[String]) -> void:
	player_names = names
#sets the  player name values
	
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	#runs as soon as the game starts
	print(player_names)
	$CanvasLayer/Player1Label.text = player_names[0]
	#outputs the player names next to the scores


	
	
	score_label.visible = true

	fire()
	update_score()
	$"."/board/pockets.body_entered.connect(pocketed_carrom)
	new_game()
#This for whne you start the game you want the carroms to be 
#generated in the correct lcoations,as thye have a set layout
 #instead of creating an individual scene for each ball,which is long and tedious we are goin instantiate it 
 #multiple time such that it always starts in the correct positions.
func new_game():
	generate_carroms()
	
func generate_carroms():
	#instantiates 8 different  black carrp,s 
		for x in range(8):
			var x_pos = c_positions[0][x]
			var y_pos = c_positions[1][x]
			var b = carrom.instantiate()
			var pos = Vector2(x_pos,y_pos)
			add_child(b)
			b.add_to_group("carrom_black")
			b.add_to_group("all_pieces")

			b.position = pos
			b.get_node("Sprite2D").texture = load("res://assets/black_carrom_new.png")
		#instantiates 4 white carroms 
		for y in range(4):
			var x_pos1 = c_positions_white[0][y]
			var y_pos1 = c_positions_white[1][y]
			var c = carrom.instantiate()
			var pos2 = Vector2(x_pos1,y_pos1)
			add_child(c)
			c.add_to_group("carrom_white")
			c.add_to_group("all_pieces")

			c.position = pos2
			c.get_node("Sprite2D").texture = load("res://assets/white_carrom_new.png")
		#instantiates 1 red carroms 
		var d = carrom.instantiate()
		var pos3 = Vector2(0,0)
		add_child(d)
		d.position = pos3
		d.add_to_group("all_pieces")
		d.add_to_group("carrom_red")
		d.get_node("Sprite2D").texture = load("res://assets/New Piskel-1.png.png")
		


func apply_aim_line_settings() -> void:
	if aim_line != null:
		aim_line.visible = aim_line_enabled

func apply_friction_settings():
	for p in get_tree().get_nodes_in_group("all_pieces"):
		if p is RigidBody2D:
			p.linear_damp = 1.5 if friction_enabled else 0.0


func is_game_finished() -> bool:
	#checks if all the groups are empty to see if the game has finished
	if get_tree().get_nodes_in_group("carrom_black").is_empty() and 	get_tree().get_nodes_in_group("carrom_white").is_empty() and 	get_tree().get_nodes_in_group("carrom_red").is_empty() == true:
		return true
	else:
		return false
		


	






func output_winner():
	#goes throuhg all the scores to see who has the best score
	
	for i in range(3):
		if carrom_spawn_pos[2][i] > max_score:
			max_score = carrom_spawn_pos[2][i]
			max_index = i
	print("the winner is",player_names[max_index],"with a score of",max_score)
			
	


func _physics_process(_delta):
	#runs every frame
	if is_game_finished() == true:
		#once the game is finished it outputs the winner
		output_winner()
		
	
	if not can_shoot and shot_taken and all_stopped():
		can_shoot = true
		#lets the next striker spawn in
	
	if all_stopped():
		#spawns in the new location
		update_striker_location(_delta)

	if Input.is_action_just_pressed("ui_accept") and can_shoot == true:
		if current_striker == null:
			fire()
			shot_taken = false

		elif shot_taken == false:
			can_shoot = false
			(current_striker as RigidBody2D).freeze = false
			current_striker.call_deferred("shoot_towards", get_global_mouse_position(), current_power)
			shot_taken = true

		else:
			current_striker.queue_free()
			current_striker = null
			count_c += 1
			if count_c == 4:
				count_c = 0
			fire()
			shot_taken = false

	update_score()

	if current_striker == null or !is_instance_valid(current_striker):
		return

	var rb := current_striker as RigidBody2D
	if not aim_line_enabled:
		aim_line.visible = false
		return
	
	#when the carroms or striker are moving it automaticaly hiodes the aimline.
	if rb != null and rb.linear_velocity.length() > 0.1:
		aim_line.visible = false
		return
	else:
		aim_line.visible = true


	var start_line := current_striker.global_position
	var dir := get_global_mouse_position() - start_line
	dir = dir.limit_length(max_aim_length)
	current_power = dir.length()
	aim_line.points = [start_line, start_line + dir]

func all_stopped():
	for p in get_tree().get_nodes_in_group("all_pieces"):
		if p.linear_velocity.length() > stop_speed:
			return false

	return true
	
	
func update_striker_location(delta):
	if not can_shoot or shot_taken:
		return


	if all_stopped() == true:
		
		min_x = striker_boundaries[count_c][0]
		max_x = striker_boundaries[count_c][1]
		min_y = striker_boundaries[count_c][2]
		max_y = striker_boundaries[count_c][3]

		var direction := 0
		var direction_y := 0 

		if Input.is_action_pressed("ui_left"):
			direction -= 1
			print("moved left")
		if Input.is_action_pressed("ui_right"):
			direction += 1
			print("moved right")
			
		current_striker.position.x += direction * striker_slide_velocity * delta
		current_striker.position.x = clamp(
			current_striker.position.x,
			min_x,
			max_x
		)
		if Input.is_action_pressed("ui_up"):
			direction_y -= 1
			print("moved up")
		if Input.is_action_pressed("ui_down"):
			direction_y += 1
			print("moved down")
			
		current_striker.position.y += direction_y * striker_slide_velocity * delta
		current_striker.position.y = clamp(
			current_striker.position.y,
			min_y,
			max_y
		)


func fire():
	#interates through the spawn posistions 
	count_c += 1
	if count_c == 4:
		count_c = 0	
	if current_striker != null:
		current_striker.queue_free()

	current_striker = striker.instantiate()
	current_striker.add_to_group("striker")
	current_striker.add_to_group("all_pieces")
	add_child(current_striker)
	#instanitates the new striker in the new position
	var x_pos_c = carrom_spawn_pos[0][count_c]
	var y_pos_c = carrom_spawn_pos[1][count_c]
	start_pos=Vector2(x_pos_c,y_pos_c)
	current_striker.global_position = start_pos


func pocketed_carrom(body: Node) -> void:
	
	#checks what the group of the carroms entered was so that the correct score can be added
	var score_to_be_added := 0
	if body is RigidBody2D:
		body.queue_free()
		print("carrom potted")
	if body.is_in_group("carrom_black"):
		print("black potted")
		score_to_be_added +=black_score

	if body.is_in_group("carrom_white"):
		print("white potted")
		score_to_be_added +=white_score

	if body.is_in_group("carrom_red"):
		print("red potted")
		score_to_be_added +=red_score

	if body.is_in_group("striker"):
		print("striker potted")
		score_to_be_added +=carrom_score
		
	var scoring_player := count_c - 1
	if scoring_player < 0:
		scoring_player = 3

	carrom_spawn_pos[2][scoring_player] += score_to_be_added
	carrom_spawn_pos[2][scoring_player] = max(carrom_spawn_pos[2][scoring_player], 0)

	print(carrom_spawn_pos[2])
	await get_tree().process_frame
#

	
func update_score():
	#displays the new score every frame.
	var s := ""
	for x in range(4):
		s += "%s score: %d\n" % [player_names[x], carrom_spawn_pos[2][x]]
	score_label.text = s

	
	
		



	


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta: float) -> void:
	pass


func _on_quit_pressed() -> void:
	get_tree().quit()

func settings() -> void:
	var settings_ui = settings_scene.instantiate()
	settings_ui.previous_scene = self
	visible = false
	get_tree().root.add_child(settings_ui)
	get_tree().current_scene = settings_ui
