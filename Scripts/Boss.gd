extends CharacterBody2D

@export var attack_collision_left : Vector2
@export var attack_collision_right: Vector2
@export var projectile : PackedScene
@export var damageable : bool = true
@export var can_shoot : bool = false

@onready var animation = $AnimationPlayer
@onready var timer = $Timer
@onready var nav_agent = $NavigationAgent2D
@onready var sprite = $Sprite2D
@onready var willshoot = $WillShoot
@onready var checkwall = $CheckWall
@onready var damagearea = $DamageArea/CollisionShape2D
@onready var attackarea = $DamageArea/CollisionShape2D

var flipped : bool = false
var jumped : bool = true
var movement_speed = 50

var player
var direction : Vector2
var hp = 1000

enum State {FLOAT, ATTACK, SHOOT, DAMAGE, WALK, IDLE, BLOCK}
var _state


func _ready():
	_state = State.IDLE

func _physics_process(delta):
	check_death()
	
	if flipped:
		sprite.flip_h = false
		damagearea.position = attack_collision_right
		attackarea.position = attack_collision_right
	else:
		sprite.flip_h = true
		damagearea.position = attack_collision_left
		attackarea.position = attack_collision_left
	
	if willshoot.is_colliding(): 
		animation.play("shoot")
		can_shoot == true
		timer.start(.45)
	if player and checkwall.is_colliding(): jump()
		
	if player : direction = check_direction(player)
	
	if _state == State.SHOOT or _state == State.ATTACK:
		#cannot move
		pass
		
	if _state == State.FLOAT and player:
		direction = to_local(nav_agent.get_next_path_position()).normalized()
		makepath(player)
		velocity = direction * movement_speed
	elif _state == State.BLOCK:
		#cant move
		pass
	else:
		if direction:
			velocity.x = direction.x * movement_speed	
		else:
			velocity.x = move_toward(velocity.x, 0, movement_speed)
		move_and_slide()
		
	



func makepath(player: Node2D) -> void:
	nav_agent.target_position.x = player.position.x
	nav_agent.target_position.y = player.position.y + 85


func check_death():
	if hp <= 0:
		die()

func attack():
	animation.play("stomp")

func jump():
	pass
	
func bfloat():
	pass

func shoot():
	var bullet = projectile.instantiate()
	owner.add_child(bullet)
	bullet.position = position
	if flipped: 
		bullet.set_direction(Vector2.LEFT)
	else:
		bullet.set_direction(Vector2.RIGHT)

func block():
	animation.play("block")
	
func take_damage(damage : int):
	hp -= damage
	animation.play("hurt")
	
func die():
	$DamageArea.monitoring = false
	$AttackArea.monitoring = false
	$CollisionShape2D.disabled = true
	animation.play("death")

func check_direction(player : CharacterBody2D) -> Vector2:
	if player.position < self.position:
		flipped = false
		return Vector2.LEFT
	else:
		flipped = true
		return Vector2.RIGHT


func _on_damage_area_body_entered(body):
	if body.has_method("mc"):
		body.take_damage(2)

func _on_damage_area_body_exited(body):
	pass # Replace with function body.


func _on_attack_area_body_entered(body):
	if body.has_method("mc"):
		attack()


func _on_attack_area_body_exited(body):
	pass # Replace with function body.


func _on_animation_player_animation_finished(anim_name):
	if anim_name == "shoot":
		_state = State.IDLE
	
func _on_detection_area_body_entered(body):
	if body.has_method("mc"):
		player = body


func _on_detection_area_body_exited(body):
	if body.has_method("mc"):
		player = null


func _on_timer_timeout():
	if(can_shoot):
		shoot()
		_state == State.IDLE
