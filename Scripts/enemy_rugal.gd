extends Area2D

@export var speed: float = 15.0
@export var move_direction: float = -1.0
var death: bool = false
var velocityX: float = 0.0
var velocityY: float = 0.0

@onready var sprite = $AnimatedSprite2D
@onready var player: CharacterBody2D = $"../Camera2D/AnimatedShip"

func _physics_process(delta: float) -> void:
	if !death:
		if sprite.animation == "Straight":
			velocityX = (speed * 2) * move_direction * delta
		else:
			velocityX = speed * move_direction * delta
		
		if player:
			var distance_y: float = (player.global_position.y - 7) - global_position.y
			
			if distance_y < -2:
				velocityY = -speed * delta
			elif distance_y > 2:
				velocityY = speed * delta
			else:
				velocityY = 0
		else:
			velocityY = 0
		move_and_slide()
	animate()

func move_and_slide() -> void:
	var teste: Vector2
	teste.x = velocityX
	teste.y = velocityY
	position += teste

func animate():
	if !death:
		if velocityY < 0:
			sprite.play("Up")
		elif velocityY > 0:
			sprite.play("Down")
		else:
			sprite.play("Straight")
	else:
		sprite.play("Die")

func die() -> void:
	$CollisionShape2D.set_deferred("disabled", true)
	print("e matou")
	death = true

func _on_animated_sprite_2d_animation_finished() -> void:
	if sprite.animation == "Die":
		queue_free()

func _on_body_entered(body: Node2D) -> void:
	if body.is_in_group("Player"):
		body.die()
