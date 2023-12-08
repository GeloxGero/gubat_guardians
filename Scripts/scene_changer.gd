extends CanvasLayer

const Level1 = preload("res://Scenes/LevelA3.tscn")
const Level2 = preload("res://Scenes/LevelA2.tscn")

func changeStage(stage_path, x, y):
	
	var stage = stage_path.instantiate()
	get_tree().get_root().get_child(1).free()
	get_tree().get_root().add_child(stage)
	stage.get_node("Player").position = Vector2(100, 100)
