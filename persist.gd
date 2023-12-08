extends Node

var save_path = "user://data.save"

var Scene1
var Scene2
var Scene3
var Player
var Globals




# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta):
	pass

func save():
	var file = FileAccess.open(save_path, FileAccess.WRITE)
	file.store_var(Scene1)
	file.store_var(Scene2)
	file.store_var(Scene3)
	file.store_var(Player)
	file.store_var(Globals)
	#file.store_var()

func load_data():
	if FileAccess.file_exists(save_path):
		var file = FileAccess.open(save_path, FileAccess.READ)
		Scene1 = file.get_var(Scene1)
		Scene2 = file.get_var(Scene2)
		Scene3 = file.get_var(Scene3)
		Player = file.get_var(Player)
		Globals = file.get_var(Globals)

func update_data(data: Dictionary, res: String):
	match res:
		"Scene1":
			Scene1 = data
		"Scene2":
			Scene2 = data
		"Scene3":
			Scene3 = data
		"Player":
			Player = data
		"Globals":
			Globals = data
	
	save()

func reset():
	Scene1 = null
	Scene2 = null
	Scene3 = null
	Player = null
	Globals = null
