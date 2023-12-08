extends CanvasLayer

func _ready():
	$PauseUI.hide()


func _process(_delta):
	if Global.hp == 5:
		$Hearts.set_frame(0)
	elif Global.hp == 4:
		$Hearts.set_frame(1)
	elif Global.hp == 3:
		$Hearts.set_frame(2)
	elif Global.hp == 2:
		$Hearts.set_frame(3)
	elif Global.hp == 1:
		$Hearts.set_frame(4)
	elif Global.hp == 0:
		$Hearts.set_frame(5)
	
	
	if Global.trash == 0:
		$Trash/Label.text = ""
	else:
		$Trash/Label.text = str(Global.trash)


func _on_pause_button_pressed():
	get_tree().paused = true
	$PauseUI.show()

func _on_play_button_pressed():
	get_tree().paused = false
	$PauseUI.hide()


func _on_g_restart_button_pressed():
	restart()


func _on_p_restart_button_pressed():
	restart()

func game_over():
	get_tree().paused = true
	$GameOverUI.show()


func restart():
	Global.reset()
	Persist.reset()
	$GameOverUI.hide()
	get_tree().paused = false
	StageManager.restart()



