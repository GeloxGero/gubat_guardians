extends Node

var bg = load("res://Assets/Audio/BG.mp3")

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


func play_music():
	
	$Music.stream = bg
	$Music.play()
