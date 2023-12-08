extends CanvasLayer



const Level1 = "res://Scenes/LevelA1.tscn"
const Level2 = "res://Scenes/LevelA2.tscn"
const Level3 = "res://Scenes/LevelA3.tscn"


func changeStage(stage_path):
#	get_node("anim").play("transin")
#	await get_node("anim").animation_finished
	
	get_tree().change_scene_to_file(stage_path)
	
#	get_node("anim").play("transout")
#	await get_node("anim").animation_finished
#	get_node("ColorRect").hide()
	
	
func restart():
	get_tree().change_scene_to_file("res://Scenes/LevelA1.tscn")

