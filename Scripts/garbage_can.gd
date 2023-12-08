extends Area2D


# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta):
	pass



func _on_area_entered(area):
	if area.has_method("garbage"):
		area.get_parent().remove_child(area)
		area.queue_free()


func _on_area_exited(_area):
	pass # Replace with function body.


func _on_body_entered(body):
	if body.has_method("mc"):
		body.clear_inventory()


func _on_body_exited(_body):
	pass # Replace with function body.
