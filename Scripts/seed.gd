extends StaticBody2D




func _on_area_2d_area_entered(body):
	print(body.name)
	if body.name == "Player":
		"Touching"
		self.queue_free()



func _on_seed_box_body_entered(body):
	if body.name == "Player":
		self.queue_free()
		Global.hp += 1


func _on_seed_box_body_exited(body):
	pass # Replace with function body.
