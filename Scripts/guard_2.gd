extends CharacterBody2D

@onready var sprite = $Sprite2D
@onready var wallchecker = $WallChecker
@onready var playerchecker = $PlayerChecker
@onready var timer = $Timer

@export var projectile: PackedScene

enum State {WALK, CHASE, IDLE, DAMAGED, DEATH, ATTACK}
var player
var flipped
var direction
var can_shoot = true

func _ready():
	print(sprite)
	print(timer)

func _physics_process(delta):
	check_death()
	if player:
		direction = check_direction(player)
	
	if direction == Vector2.LEFT:
		flipped = true
		sprite.flip_h = true
		wallchecker.rotation_degrees = 90
		playerchecker.rotation_degrees = 90
	elif direction == Vector2.RIGHT:
		flipped = false
		sprite.flip_h = false
		wallchecker.rotation_degrees = -90
		playerchecker.rotation_degrees = -90
	
	if playerchecker.is_colliding() and can_shoot:
		shoot()
		can_shoot = false
		timer.start(1)
	




func check_death():
	pass

func jump():
	pass
	
func shoot():
	var bullet = projectile.instantiate()
	owner.add_child(bullet)
	bullet.position = position
	if flipped: 
		bullet.set_direction(Vector2.LEFT) 
	else:
		bullet.set_direction(Vector2.RIGHT)

func check_direction(player : CharacterBody2D) -> Vector2:
	if player.position < self.position:
		flipped = false
		return Vector2.LEFT
	else:
		flipped = true
		return Vector2.RIGHT


func _on_area_2d_body_entered(body):
	if body.has_method("mc"):
		player = body


func _on_area_2d_body_exited(body):
	if body.has_method("mc"):
		player = null


func _on_timer_timeout():
	can_shoot = true
