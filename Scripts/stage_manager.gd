extends CanvasLayer

const Level1 = preload("res://Scenes/LevelA3.tscn")
const Level2 = preload("res://Scenes/LevelA2.tscn")

func changeStage(stage_path):
	
	get_tree().change_scene_to_file(stage_path)
	

