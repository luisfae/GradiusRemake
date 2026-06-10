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
	var padding := Vector2(15, 15) #valores hard coded q seriam o tamanho da nave, mas a sprite tem tamanho maior q a nave em si
	position.x = clampf(position.x, -half_screen.x + padding.x, half_screen.x - padding.x)
	position.y = clampf(position.y, -half_screen.y + padding.y, half_screen.y - padding.y)

func animate():
	if velocity.y < 0:
		sprite.play("Up")
	elif velocity.y > 0:
		sprite.play("Down")
	else:
		sprite.play("Standard")
		
