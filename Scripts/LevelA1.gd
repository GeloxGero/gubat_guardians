extends Node2D

@export var limit_x_left : int
@export var limit_x_right : int
@export var limit_y_up : int
@export var limit_y_down : int

var y_offset = -82
# Called when the node enters the scene tree for the first time.

var Garbage = preload("res://assets/Environment/Misc/Trash/Garbage.tscn")
var Enemy = preload("res://assets/Entities/Enemy/Woodcutter/wood_cutter.tscn")

var data

func _initial_data():
	data = {
		"player": null,
		"garbage": [],
		"enemy": [],
	}

func inst(node: PackedScene, position: Vector2):
	var object = node.instantiate()
	if object.has_method("enemy"):
		data.enemy.append({
			"position_y" = position.y,
			"position_x" = position.x
		})
	add_child(object)
	object.position = position

func update_player():
	var player = $Player
	data.player = {
		"position_y" = player.position.y,
		"position_x" = player.position.x
	}

func _ready():	
	if !Persist.Scene1:
		_initial_data()
		inst(Enemy, Vector2(664, -194))
		inst(Enemy, Vector2(903, -164))
		inst(Enemy, Vector2(1563, -97))
		update_player()
	else:
		data = Persist.Scene1
		$Player.position = Vector2(data.player.position_x, data.player.position_y)
	
	DialogueManager.show_example_dialogue_balloon(load("res://assets/Words/initial.dialogue"), "level1")
	#MusicController.play_music()

	
	
	var camera = get_node("Player/Camera2D")
	camera.limit_left = limit_x_left
	camera.limit_right = limit_x_right
	camera.limit_top = limit_y_up
	camera.limit_bottom = limit_y_down
	

func _on_edge_right_body_entered(body):
	if body.name == "Player":
		update_player()
		data.player.position_x -= 50
		Persist.update_data(data, "Scene1")
		get_tree().change_scene_to_file(StageManager.Level2)


func _on_edge_right_body_exited(body):
	if body.has_method("player"):
		Global.transition_scene = false

func _on_area_2d_body_entered(body:Node2D) -> void:
	if body.has_method("mc"):
		body.die()
