extends CharacterBody2D


@export var speed := 50.0
@onready var sprite = $AnimatedSprite2D
#@export var bullet: PackedScene
@onready var bullet = preload("res://bullet.tscn")

func get_input():
	var input_directionX := Input.get_axis("left", "right")
	velocity.x = input_directionX * speed
	
	var input_directionY := Input.get_axis("up", "down")
	velocity.y = input_directionY * speed
	
	if Input.is_action_just_pressed("r1"):
		speed += 25
	
	if Input.is_action_just_pressed("fire"):
		print("shoot")
		var b = bullet.instantiate() as Bullet
		b.position = global_position # tem q usar a global_pos pq a nave agr eh filha da camera
		b.position.y -= 8 # numero hard coded pra sair do meio da nave
		owner.add_child(b)


func _physics_process(delta: float) -> void:
	get_input()
	animate()
	move_and_slide()
	
	# Codigo teste para limitar a nave de sair da tela
	var half_screen := get_viewport_rect().size / 2.0
	var padding := Vector2(20, 12) # esse 20 eh hard coded, se fosse o tamanho da nave real q eh 26, ela nao vai tao pra < quanto no jogo original
	position.x = clampf(position.x, -half_screen.x + padding.x, half_screen.x - padding.x)
	position.y = clampf(position.y, -102 + padding.y, 98 - padding.y)
	print(half_screen)

func animate():
	if velocity.y < 0:
		sprite.play("Up")
	elif velocity.y > 0:
		sprite.play("Down")
	else:
		sprite.play("Standard")
		
