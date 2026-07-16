extends Area2D
class_name Fan

enum State { ADVANCE, DIAGONAL, RETROCEDE }
var current_state: State = State.ADVANCE

@export var speed: float = 60.0
@export var diagonalAcceleration: float = 40.0
@export var health: int = 1
@export var topLimit := 40.0 # limites que ele vai, ele nao vai até os cantos
@export var bottomLimit := 160.0

var camera: Camera2D = null
var points: int = 100
var death: bool = false
var dropUpgrade: bool = false
var movement_vector: Vector2 = Vector2.ZERO


@onready var sprite = $AnimatedSprite2D
@onready var screen_width: float = get_viewport().get_visible_rect().size.x
@onready var player: CharacterBody2D = get_tree().get_first_node_in_group("Player") as CharacterBody2D

func _ready() -> void:
	camera = get_viewport().get_camera_2d()

func _physics_process(delta: float) -> void:
	if !camera or death:
		return
		
	match current_state:
		State.ADVANCE:
			# avança pra esquerda até atingir o X desejado, sendo esse + - 40% da tela contando da esquerda pra direita
			movement_vector.x = -speed * 1.5 
			movement_vector.y = 0
			
			# calculo de onde é esse ponto
			var camera_left_edge = camera.global_position.x - (screen_width / 2.0)
			var target_turn_x = camera_left_edge + (screen_width * 0.40)
			
			# troca de estado se chegou
			if global_position.x <= target_turn_x:
				current_state = State.DIAGONAL
				speed += diagonalAcceleration
				
		State.DIAGONAL:
			# se move na diagonal pra baixo e direita
			movement_vector.x = speed
			
			# alinha o y com o player
			if player and is_instance_valid(player):
				# se o player estiver acima sobe (-1) e se estiver abaixo desce (1).
				var y_direction = sign(player.global_position.y - global_position.y)
				movement_vector.y = y_direction * speed
				
				# se Y alinhar (com uma folguinha), muda pra retrocede, ou se ele chega aos limites que ele alcança, retrocede tbm
				if abs(global_position.y - player.global_position.y) < 5.0 or global_position.y <= topLimit or global_position.y >= bottomLimit:
					current_state = State.RETROCEDE
			else:
				# se o player morreu tbm retroce
				current_state = State.RETROCEDE
				
		State.RETROCEDE:
			# vai reto pra direita até sair da tela
			movement_vector.x = speed * 2.0
			movement_vector.y = 0

	global_position += movement_vector * delta

func _on_area_entered(area: Area2D) -> void:
	if area.is_in_group("Player Projectiles"):
		area.die()
		takeHit()

func _on_body_entered(body: Node2D) -> void:
	if body.is_in_group("Player"):
		body.takeHit()
		if body.isShieldUp():
			takeHit()

func _on_visible_on_screen_notifier_2d_screen_exited() -> void:
	print("saiu de tela")
	queue_free()

func setDropUpgrade() -> void:
	dropUpgrade = true

func die() -> void:
	$CollisionShape2D.set_deferred("disabled", true)
	AudioManager.play_sfx_enemyDeath()
	print("e matou")
	death = true
	sprite.play("Die")

func givePoints() -> void:
	GlobalVars.receiveScore(points)
	
func setPoints(points_: int) -> void:
	points = points_
	
func _on_animated_sprite_2d_animation_finished() -> void:
	if sprite.animation == "Die":
		if dropUpgrade:
			GlobalVars.createUpgrade(global_position)
		queue_free()

func takeHit() -> void:
	health -= 1
	if health < 1:
		die()
		givePoints()
	
