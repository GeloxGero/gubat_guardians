extends CharacterBody2D

@export var starting_move_direction : Vector2 = Vector2.LEFT

@export var can_attack : bool

@export var health_points : int = 20
@export var attack_left_position : Vector2
@export var attack_right_position : Vector2

@onready var animation = $AnimationPlayer
@onready var nav_agent = $NavigationAgent2D
@onready var wall_check = $RayCast2D
@onready var attack_detect = $AttackingArea/AttackingDetect
@onready var attack_collide = $DamagingArea/AttackingCollide


var hitpoints = 100
var movement_speed = 30.0

enum State {WALK, CHASE, IDLE, DAMAGED, DEATH, ATTACK}

var attacking = false
var _state = State.IDLE
var speed = 30.0
var flipped = false

var gravity = 980 # The force of gravity
var jumped : bool = false
var direction: Vector2 = starting_move_direction

var player

func makepath(player: Node2D) -> void:
	nav_agent.target_position.x = player.position.x
	nav_agent.target_position.y = player.position.y + 85

func _ready():
	print(to_local(nav_agent.get_next_path_position()))
	print(to_local(nav_agent.get_next_path_position()).normalized())


func _physics_process(delta):
	check_death()
	
	var dir = to_local(nav_agent.get_next_path_position()).normalized()
	
	if wall_check.is_colliding() and player:
		jump()
	
	if jumped:
		velocity.y = -300
	
	if player:
		direction = check_direction(player)
	
	#flip sprite and area2Ds
	if flipped:
		$Sprite2D.flip_h = true
		attack_detect.position = attack_right_position
		attack_collide.position = attack_right_position
		wall_check.rotation_degrees = -90
	else:
		$Sprite2D.flip_h = false
		attack_detect.position = attack_left_position
		attack_collide.position = attack_left_position
		wall_check.rotation_degrees = 90

	if not is_on_floor():
		velocity.y += gravity * delta
		jumped = false
	

	

	match _state:
		State.IDLE:
			movement_speed = 30.0
			animation.play("idle")
		State.CHASE:
			movement_speed = 100.0
			animation.play("run")
			#velocity = direction * speed
		State.WALK:
			movement_speed = 30.0
			animation.play("walk")
		State.DAMAGED:
			movement_speed = 0
			animation.play("damaged")
		State.DEATH:
			movement_speed = 0
			animation.play("death")
		State.ATTACK:
			if can_attack:
				animation.play("attack")


	
	
	velocity.x = dir.x * speed * 5
	move_and_slide()

func temp():
	if direction:
		velocity.x = direction.x * movement_speed	
	else:
		velocity.x = move_toward(velocity.x, 0, speed)
		
	if not can_attack:
		velocity.x = 0
		
func jump():
	jumped = true

func take_damage(damage):
	hitpoints -= damage
	_state = State.DAMAGED

func check_death():
	if hitpoints <= 0:
		_state = State.DEATH

func _on_attacking_area_body_entered(body):
	if body.name == "Player":
		_state = State.ATTACK


func _on_attacking_area_body_exited(body):
	if body.name == "Player":
			can_attack = true
			$DamagingArea.monitoring = false
			_state = State.IDLE
	

func _on_damaging_area_body_entered(body):
	if body.name == "Player":
		print("Hit")
		body.take_damage(1)


func _on_damaging_area_body_exited(_body):
	pass # Replace with function body.


func _on_detection_area_body_entered(body):
	if body.name == "Player":
		player = body
		_state = State.CHASE

func _on_detection_area_body_exited(body):
	if body.name == "Player":
		player = null
		_state = State.IDLE

func _on_animation_player_animation_finished(anim_name):
	if anim_name == "death":
		self.queue_free()
	elif anim_name == "damaged":
		_state = State.IDLE

func enemy():
	pass
	
	

func check_direction(player : CharacterBody2D) -> Vector2:
	if player.position < self.position:
		flipped = false
		return Vector2.LEFT
	else:
		flipped = true
		return Vector2.RIGHT

func _on_timer_timeout():
	if player:
		makepath(player)
	else:
		pass
