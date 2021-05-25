extends KinematicBody2D

onready var _animated_player = $main_char

const gravity = 10
const up = Vector2(0, -1)
const jump = -250
const velocity = 100

var moviment = Vector2()
var attacking = false
var death = false
var direction = 1
var grounded
var attackPoints = 3
var cooldown = false

func _ready():
	pass
func _physics_process(delta):
	if death == false:
# identificar si esta en contacte amb el terra
		if is_on_floor():
			grounded = true
		else:
			grounded = false
# variacio moviments
		moviment.y += gravity
		moviment.x = 0
# controls de moviment
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
# hitbox
		if direction == 1:
			$hitbox_main/left.disabled = true
			$hitbox_main/right.disabled = false
			$left.enabled = false
			$right.enabled = true
			_animated_player.flip_h = false
		elif direction == -1:
			$hitbox_main/left.disabled = false
			$hitbox_main/right.disabled = true
			$left.enabled = true
			$right.enabled = false
			_animated_player.flip_h = true
#controls attack
		if Input.is_action_just_pressed("attack") && attackPoints == 3 && grounded == true && cooldown == false:
			$reset.start()
			$main_char.play("attack_1")
			attackPoints = attackPoints -1
			cooldown = true
			attacking = true
			if direction == 1:
				$hitbox_attack_1/right.disabled = false
				$hitbox_attack_1/left.disabled = true
			elif direction == -1:
				$hitbox_attack_1/right.disabled = true
				$hitbox_attack_1/left.disabled = false
			$cooldown.start()
		elif Input.is_action_just_pressed("attack") && attackPoints == 2 && grounded == true && cooldown == false:
			$reset.start()
			$main_char.play("attack_2")
			attackPoints = attackPoints - 1
			cooldown = true
			attacking = true
			if direction == 1:
				$hitbox_attack_2/right.disabled = false
				$hitbox_attack_2/left.disabled = true
			elif direction == -1:
				$hitbox_attack_2/right.disabled = true
				$hitbox_attack_2/left.disabled = false
			if direction == 1:
				$hitbox_attack_1/right.disabled = true
			elif direction == -1:
				$hitbox_attack_1/left.disabled = true
			$cooldown.start()
		elif Input.is_action_just_pressed("attack") && attackPoints == 1 && grounded == true && cooldown == false:
			$reset.start()
			$main_char.play("attack_3")
			attackPoints = attackPoints - 1
			cooldown = true
			attacking = true
			if direction == 1:
				$hitbox_attack_3/right.disabled = false
				$hitbox_attack_3/left.disabled = true
			elif direction == -1:
				$hitbox_attack_3/right.disabled = true
				$hitbox_attack_3/left.disabled = false
			if direction == 1:
				$hitbox_attack_2/right.disabled = true
			elif direction == -1:
				$hitbox_attack_2/left.disabled = true
			$cooldown.start()
		moviment = move_and_slide(moviment, up)
	elif death == true:
		pass

func _on_main_char_animation_finished():
	if $main_char.animation == "attack_1":
		if attackPoints == 3:
			$main_char.play("idle")
			attacking = false
	elif $main_char.animation == "attack_2":
		if attackPoints == 3:
			$main_char.play("idle")
			attacking = false
	elif $main_char.animation == "attack_3":
		$main_char.play("idle")
		attackPoints = 3
		attacking = false
		$main_char.play("idle")
		attacking = false
		if direction == 1:
			$hitbox_attack_3/right.disabled = true
		elif direction == -1:
			$hitbox_attack_3/left.disabled = true

func _on_hitbox_main_area_entered(area):
	pass
	


func _on_reset_timeout():
	attacking = false
	attackPoints = 3

func _on_cooldown_timeout():
	cooldown = false
