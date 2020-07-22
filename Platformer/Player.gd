extends KinematicBody2D

const UP = Vector2(0,-1)
const H_SPEED = 400
const ACCEL = 25
const GROUND_FRICTION = 30
const GRAVITY = 10
const JUMP_HEIGHT = -300

enum FACING {LEFT,RIGHT}

var motion = Vector2()
var doubleJump = false
var facing = FACING.LEFT

func _physics_process(delta):
	
	motion.y += GRAVITY
	
	if Input.is_action_pressed("ui_right"):
		facing = FACING.RIGHT
		motion.x = min(motion.x+ACCEL,H_SPEED)
		$Sprite.flip_h = false
		$Sprite.play("run")
		
	elif Input.is_action_pressed("ui_left"):
		facing = FACING.LEFT
		motion.x = max(motion.x-ACCEL,-H_SPEED)
		$Sprite.flip_h = true
		$Sprite.play("run")
	
	#Not pressing anything
	else:
		#Depending on the direction of facing, we slowly decelerate the sprite
		$Sprite.play("idle")
		if facing == FACING.RIGHT:
			motion.x = max(motion.x-GROUND_FRICTION,0)
			
		elif facing == FACING.LEFT:
			motion.x = min(motion.x+GROUND_FRICTION,0)
	
	if is_on_floor():
		doubleJump = false
		if Input.is_action_just_pressed("ui_select"):
			motion.y = JUMP_HEIGHT
	
	else:
		$Sprite.play("jump")
		if Input.is_action_just_pressed("ui_select") and !doubleJump:
			doubleJump = true
			motion.y = JUMP_HEIGHT-100
	
	motion = move_and_slide(motion,UP)
	
	pass
