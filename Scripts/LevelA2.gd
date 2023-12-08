extends Node2D

@export var limit_x_left : int
@export var limit_x_right : int
@export var limit_y_up : int
@export var limit_y_down : int


# Called when the node enters the scene tree for the first time.
func _ready():
	
	var camera = get_node("Player/Camera2D")
	camera.limit_left = limit_x_left
	camera.limit_right = limit_x_right
	camera.limit_top = limit_y_up
	camera.limit_bottom = limit_y_down

func _on_edge_left_body_entered(body):
	if body.name == "Player":
		get_tree().change_scene_to_file(StageManager.Level1)


func _on_edge_left_body_exited(body):
	if body.has_method("player"):
		pass


func _on_edge_right_body_entered(body):
	print(body.has_method("mc"))
	if body.has_method("mc"):
		get_tree().change_scene_to_file(StageManager.Level3)


func _on_edge_right_body_exited(body):
	pass # Replace with function body.
