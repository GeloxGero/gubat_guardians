extends Area2D

var has_player : bool = false
# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if has_player and Input.is_action_just_pressed("Interact"):
		$Sprite2D.show()


func _on_body_entered(body):
	if body.has_method("mc"):
		has_player = true
	
		


func _on_body_exited(body):
		has_player = false
