extends StaticBody2D

var above_ladder : bool = false

func _physics_process(_delta):
	if Input.is_action_pressed("down") and above_ladder:
		$CollisionShape2D.rotation_degrees = 180
	else:
		$CollisionShape2D.rotation_degrees = 0

func _on_above_checker_body_entered(_body):
	above_ladder = true


func _on_above_checker_body_exited(_body):
	above_ladder = false
