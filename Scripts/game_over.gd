extends CanvasLayer






func _on_button_pressed():
	Global.hp = 5
	get_tree().change_scene_to_file("res://Scenes/LevelA1.tscn")
