extends Area2D
class_name Rugal

@export var health: int = 1
@export var speed: float = 15.0
@export var move_direction: float = -1.0
var death: bool = false
var velocityX: float = 0.0
var velocityY: float = 0.0
var dropUpgrade: bool = false
var points: int = 100

@onready var sprite = $AnimatedSprite2D
@onready var player: CharacterBody2D = get_tree().get_first_node_in_group("Player") as CharacterBody2D

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
	var newPos: Vector2
	newPos.x = velocityX
	newPos.y = velocityY
	position += newPos

func animate():
	if !death:
		if velocityY < 0:
			sprite.play("Up")
		elif velocityY > 0:
			sprite.play("Down")
		else:
			sprite.play("Straight")

func die() -> void:
	$CollisionShape2D.set_deferred("disabled", true)
	AudioManager.play_sfx_enemyDeath()
	print("e matou")
	death = true
	sprite.play("Die")

func _on_visible_on_screen_notifier_2d_screen_exited() -> void:
	print("saiu de tela")
	queue_free()

func _on_animated_sprite_2d_animation_finished() -> void:
	if sprite.animation == "Die":
		if dropUpgrade:
			GlobalVars.createUpgrade(global_position)
		queue_free()

func _on_body_entered(body: Node2D) -> void:
	if body.is_in_group("Player"):
		body.takeHit()
		if body.isShieldUp():
			takeHit()

func _on_area_entered(area: Area2D) -> void:
	if area.is_in_group("Player Projectiles"):
		area.die()
		takeHit()
		givePoints()

func setDropUpgrade() -> void:
	dropUpgrade = true
	print("setouDropUpgrade")
	
func givePoints() -> void:
	GlobalVars.receiveScore(points)
	
func setPoints(points_: int) -> void:
	points = points_

func takeHit() -> void:
	health -= 1
	if health < 1:
		die()
	
