extends Area2D

var snap = 0
var thrown = false
var direction
var speed = 2.2
var time_limit = 2
var monitoring_player = true

var to_add = 0

# Called when the node enters the scene tree for the first time.
func _ready():
	var rand = Global.random.randi_range(1, 10)
	
	if rand == 1:
		$Sprite2D.texture.region = Rect2(128,216,32,24)
	elif rand == 2:
		$Sprite2D.texture.region = Rect2(160, 184, 16, 24)
	elif rand == 3:
		$Sprite2D.texture.region = Rect2(192, 184, 16, 24)
	elif rand == 4:
		$Sprite2D.texture.region = Rect2(224, 184, 16, 24)
	elif rand == 5:
		$Sprite2D.texture.region = Rect2(112, 216, 16, 24)
	elif rand == 6:
		$Sprite2D.texture.region = Rect2(128, 216, 32, 24)
	elif rand == 7:
		$Sprite2D.texture.region = Rect2(176, 216, 16, 24)
	elif rand == 8:
		$Sprite2D.texture.region = Rect2(208, 216, 16, 24)
	elif rand == 9:
		$Sprite2D.texture.region = Rect2(224, 216, 16, 24)
	elif rand == 10:
		$Sprite2D.texture.region = Rect2(240, 216, 16, 24)


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta):
	if thrown:
		if time_limit <= 0 : 
			thrown = false
			set_deferred("monitoring", true)
			time_limit = 2
	
		if snap == Global.TIMER:
			time_limit -= 1
			
			
		if direction == Vector2.LEFT:
			self.position -= transform.x * speed
		else:
			self.position += transform.x * speed

func throw(vector: Vector2):
	self.show()
	snap = Global.TIMER - 1
	direction = vector
	thrown = true
	
func _on_body_entered(body):
	if body.has_method("mc") and monitoring_player and self.get_parent() != body:
		set_deferred("monitoring", false)
		call_deferred("reparent", body)
		body.store_item(self)
		self.hide()

func _on_body_exited(_body):
	pass

func garbage():
	pass
