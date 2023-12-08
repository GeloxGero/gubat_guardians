extends Area2D

var speed : float = 4
var direction: Vector2


# Called when the node enters the scene tree for the first time.
func _ready():
	pass

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta):
	if direction == Vector2.LEFT:
		self.position -= transform.x * speed
	else:
		self.position += transform.x * speed

func set_direction(vector: Vector2):
	direction = vector

func _on_body_entered(body):
	if body.name == "TileMap":
		self.queue_free()
	if body.has_method("mc"):
		body.take_damage(1)
			
	if body.has_method("turret"):
		body.take_damage(20)

func playerProjectile():
	pass


func _on_body_exited(body):
	pass # Replace with function body.
