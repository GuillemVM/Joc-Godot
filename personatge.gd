extends KinematicBody2D

onready var _animated_player = $main_char

const gravity = 10
const up = Vector2(0, -1)
const jump = -200
const velocity = 100

var moviment = Vector2()
var attacking = false
var death = false
var direction = 1
var grounded
var attack_2 = false
var attack_3 = false

func _ready():
	pass
func _physics_process(delta):
	if death == false:
		if is_on_floor():
			grounded = true
		else:
			grounded = false
		moviment.y += gravity
		moviment.x = 0
		if attacking == false:
			if Input.is_action_pressed("ui_right"):
				moviment.x = velocity
			if Input.is_action_pressed("ui_left"):
				moviment.x = -velocity
			if grounded == true && Input.is_action_pressed("ui_up"):
				moviment.y = jump
			elif grounded == false && moviment.y < 0:
				_animated_player.play("jump")
			if moviment.x > 0:
				direction = 1
				if grounded == true:
					_animated_player.play("walk")
					_animated_player.flip_h = false
			elif moviment.x < 0:
				direction = -1
				if grounded == true:
					_animated_player.play("walk")
					_animated_player.flip_h = true
			elif moviment.x == 0:
				if grounded == true:
					_animated_player.play("idle")
		if direction == 1:
			$hitbox_main/left.disabled = true
			$hitbox_main/right.disabled = false
			$left.enabled = false
			$right.enabled = true
		elif direction == -1:
			$hitbox_main/left.disabled = false
			$hitbox_main/right.disabled = true
			$left.enabled = true
			$right.enabled = false
		if Input.is_action_just_pressed("attack") && grounded == true:
			attacking = true
			_animated_player.play("attack_1")
			if direction == 1:
				$hitbox_attack_1/left.disabled = true
				$hitbox_attack_1/right.disabled = false
			elif direction == -1:
				$hitbox_attack_1/left.disabled = false
				$hitbox_attack_1/right.disabled = true
		if _animated_player.animation == "attack_1":
			if Input.is_action_just_pressed("attack"):
				attack_2 = true
			else:
				pass
		if _animated_player.animation == "attack_2":
			if Input.is_action_just_pressed("attack"):
				attack_3 = true
			else:
				pass
		moviment = move_and_slide(moviment, up)
	elif death == true:
		pass

func _on_main_char_animation_finished():
	if _animated_player.animation == "attack_1":
		if direction == 1:
			$hitbox_attack_1/right.disabled = true
		elif direction == -1:
			$hitbox_attack_1/left.disabled = true
		if attack_2 == true:
			_animated_player.play("attack_2")
			if direction == 1:
				$hitbox_attack_2/right.disabled = false
			if direction == -1:
				$hitbox_attack_2/left.disabled = false
		else:
			_animated_player.play("idle")
			attacking = false
	if _animated_player.animation == "attack_2":
		attack_2 = false
		if direction == 1:
			$hitbox_attack_2/right.disabled = true
		if direction == -1:
			$hitbox_attack_2/left.disabled = true
		if attack_3 == true:
			_animated_player.play("attack_3")
			if direction == 1:
				$hitbox_attack_3/right.disabled = false
			if direction == -1:
				$hitbox_attack_3/left.disabled = false
		else:
			_animated_player.play("idle")
			attacking = false
	if _animated_player.animation == "attack_3":
		attack_3 = false
		if direction == 1:
			$hitbox_attack_3/right.disabled = true
		if direction == -1:
			$hitbox_attack_3/left.disabled = true
		_animated_player.play("idle")
		attacking = false

func _on_hitbox_main_area_entered(area):
	pass
