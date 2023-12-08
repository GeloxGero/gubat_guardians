extends CharacterBody2D

var y_offset = -82

var inventory = []

var previous_scene_position : Vector2



enum States {ON_GROUND, IN_AIR, CLIMB, DROP, CROUCH, SWIM, DAMAGED}
@export var player_position : Vector2
@onready var animation = $AnimationPlayer
# Member variables
@export var speed: float = 140
@export var jump_force: float = 1.2
@export var projectile: PackedScene

var player
var flipped = false
var _state : int = States.ON_GROUND

var jumpval : int = 2
var lock_x : bool = false
var on_ladder : bool = false


var jump_speed = -250 # Negative because 2D space's y-axis is down
var gravity = 980 # The force of gravity

var interact : bool = false

func _physics_process(delta):	
	
	
	if Global.TIMER <= 60:
		Global.TIMER += 1
	else:
		Global.TIMER -= 60
	
	
	player_position = position
	
	if(_state == States.IN_AIR):
		if not $AnimationPlayer.current_animation == "jump": 
			_state = States.DROP

	# continuous click
	var up = Input.is_action_pressed('up')
	var right = Input.is_action_pressed('right')
	var left = Input.is_action_pressed('left')
	
	
	# per click
	interact = Input.is_action_just_pressed("Interact")
	if Input.is_action_just_pressed("Shoot"):
		shoot()
	if Input.is_action_just_pressed("Temp"):
		print(position)
	if Input.is_action_just_pressed("throw"):
		throw()
	var down = Input.is_action_just_pressed('down')
	var jump = Input.is_action_just_pressed('jump')
	var direction = Vector2()
	
	var on_floor = is_on_floor()
	
	if on_floor and _state != States.CROUCH and _state != States.CLIMB:
		if not _state == States.DAMAGED:
			_state = States.ON_GROUND
	
	match _state:
		States.ON_GROUND:
			jumpval = 2
			lock_x = false
		States.DROP:
			animation.play("fall")
		States.CLIMB:
			jumpval = 2
			down = Input.is_action_pressed('down')
			velocity.y = 0
			gravity = 0
			if not on_ladder:
				_state = States.DROP
				gravity = 980
		States.DAMAGED:
			animation.play("damaged")
	
	if(jump):
		if on_ladder:
			_state = States.DROP
			gravity = 980
		elif jumpval > 0:
			jumpval -= 1
			animation.play("jump")
			velocity.y = jump_speed * jump_force
			_state = States.IN_AIR
	elif(up):
		if on_ladder:
			if _state == States.CLIMB:
				velocity.y = -80
				animation.play("climb")
			else:
				_state = States.CLIMB
		elif _state == States.CROUCH:
			_state = States.ON_GROUND
	elif(down):
		if on_ladder:
			if _state == States.CLIMB:
				velocity.y = 80
				animation.play("climb")
			else:
				_state = States.CLIMB
		if _state == States.ON_GROUND:
			_state = States.CROUCH
	elif(right and not lock_x):
		flipped = false
		if _state == States.ON_GROUND:
			animation.play("run")
		$Sprite2D.flip_h = false
		direction.x += 1
	elif(left and not lock_x):
		flipped = true
		if _state == States.ON_GROUND:
			animation.play("run")
		$Sprite2D.flip_h = true
		direction.x -= 1

	else:
		if _state == States.ON_GROUND:
			animation.play("idle")
		
	

	# Normalize direction
	direction = direction.normalized()


	# Apply horizontal movement
	velocity.x = direction.x * speed
	velocity.y += gravity * delta
	

	
	
	
	# Move the character
	set_velocity(velocity)
	set_up_direction(Vector2.UP)
	move_and_slide()


func move():
	pass
	

	
func shoot():
	var boko = projectile.instantiate()
	owner.add_child(boko)
	boko.position = position
	if flipped: 
		boko.set_direction(Vector2.LEFT) 
	else:
		boko.set_direction(Vector2.RIGHT)
		
	

	
func throw():
	if inventory.size() == 0 or not inventory:
		return
	
	var garbage = inventory.pop_back()
	self.remove_child(garbage)
	owner.add_child(garbage)
	garbage.position = Vector2(position.x, position.y)
	
	if flipped:
		garbage.throw(Vector2.LEFT)
	else:
		garbage.throw(Vector2.RIGHT)
	
	Global.trash = inventory.size()


func store_item(item: Area2D):
	inventory.append(item)
	Global.trash = inventory.size()

func clear_inventory():
	inventory = []
	Global.trash = inventory.size()

func mc():
	pass

func die():
	$UI.game_over()

func take_damage(damage):
	_state = States.DAMAGED
	if Global.hp == 1:
		die()
	Global.hp -= damage
	

func _on_animation_player_animation_finished(anim_name):
	if anim_name == "damaged":
		_state = States.ON_GROUND


func _on_ladder_checker_body_entered(body):
	if body.name == "TileMap2":
		on_ladder = true
	

func _on_ladder_checker_body_exited(body):
	if body.name == "TileMap2":
		on_ladder = false
	
