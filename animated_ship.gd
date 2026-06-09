extends CharacterBody2D


@export var speed := 200.0
@onready var sprite = $AnimatedSprite2D

func get_input():
	var input_directionX := Input.get_axis("left", "right")
	velocity.x = input_directionX * speed
	
	var input_directionY := Input.get_axis("up", "down")
	velocity.y = input_directionY * speed


func _physics_process(delta: float) -> void:
	get_input()
	animate()
	move_and_slide()

func animate():
	if velocity.y < 0:
		sprite.play("Up")
	elif velocity.y > 0:
		sprite.play("Down")
	else:
		sprite.play("Standard")
		
