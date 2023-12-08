extends CharacterBody2D

var speed: float = 100
var gravity: float = 2000
var direction: Vector2 = Vector2.RIGHT
var random = RandomNumberGenerator.new()
@onready var animation = $AnimationPlayer

# Initialize mob state
enum States {IDLE, FLYING}
var state: States = States.IDLE

# Handle movement
func _physics_process(delta):
	var rand = random.randf_range(1, 1000)
	
	if state == States.IDLE:
		animation.play("idle")
	elif state == States.FLYING:
		animation.play("fly")
		direction = Vector2(random.randf() - 0.5, random.randf() - 0.5)
		velocity = direction * speed
		velocity.x = randi_range(200, 600)
		gravity = -1500
		
		
	velocity.y += gravity * delta
	set_velocity(velocity)
	set_up_direction(Vector2.UP)
	move_and_slide()



func _on_area_2d_body_entered(body):
	print(body)
	if body.name == "Player":
		state = States.FLYING
	

