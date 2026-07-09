extends Area2D
class_name Dakker

enum State { INTRUDER, STATIONARY, CHASING } # PS.: Ainda em construção
var current_state: State = State.INTRUDER

@export var fire_rate: float = 3.0
@export var speed: float = 60.0

@export var health: int = 1
var dropUpgrade: bool = false
var death: bool = false
var points: int = 100
var shoot_timer: Timer
var movement_vector: Vector2 = Vector2.ZERO
var is_on_ceiling: bool = false

@onready var projectile = preload("res://Scenes/projectile_enemy.tscn")
@onready var sprite = $AnimatedSprite2D
@onready var player: CharacterBody2D = get_tree().get_first_node_in_group("Player") as CharacterBody2D
@onready var crosshair = $Crosshair
@onready var camera: Camera2D = get_viewport().get_camera_2d()
@onready var ray_down: RayCast2D = $RayCastDown
@onready var ray_up: RayCast2D = $RayCastUp
@onready var screen_width: float = get_viewport().get_visible_rect().size.x

func _ready() -> void:
	ray_down.force_raycast_update()
	ray_up.force_raycast_update()
	if ray_down.is_colliding():
		print("detectou chão")
		sprite.flip_v = false
	elif ray_up.is_colliding():
		print("detectou teto")
		sprite.flip_v = true
		crosshair.position.y *= -1
	else:
		print("nao detectou nada")
	
	if !player:
		return
		
	if global_position.y < player.global_position.y:
		is_on_ceiling = true
		sprite.flip_v = true
		crosshair.position.y *= -1
	else:
		is_on_ceiling = false
		sprite.flip_v = false
	
	shoot_timer = Timer.new()
	shoot_timer.wait_time = fire_rate
	shoot_timer.autostart = true
	shoot_timer.timeout.connect(_on_shoot_timer_timeout)
	add_child(shoot_timer)

func _process(delta: float) -> void:
	if death or !player: 
		return
		
	manage_ai_and_movement(delta)

func manage_ai_and_movement(delta: float) -> void:
	# Alinha com a velocidade real do teu scroll em pixels por segundo
	var camera_scroll_speed = 30.0 
	
	# Pega o limite esquerdo e direito visível da câmara atual
	var camera_left_edge = camera.global_position.x - (screen_width / 2.0)
	
	# --- MÁQUINA DE ESTADOS COMPORTAMENTAL CORRIGIDA ---
	match current_state:
		
		State.INTRUDER:
			# O robô nasce na direita e caminha para a esquerda
			movement_vector.x = -speed
			shoot_timer.paused = true
			sprite.play("Walk")
			
			# META DE PARAGEM FIXA: Ele para quando chega a 65% do ecrã (vindo da direita)
			# Isto remove a dependência do X do Player, eliminando o piscar!
			var target_stop_x = camera_left_edge + (screen_width * 0.65)
			if global_position.x <= target_stop_x:
				current_state = State.STATIONARY

		State.STATIONARY:
			# Fica preso ao scroll da câmara a bombardear
			movement_vector.x = camera_scroll_speed
			shoot_timer.paused = false
			sprite.play("Still")
			
			# TRANSIÇÃO: Só sai deste estado se o jogador avançar muito rápido 
			# e o robô ficar para trás da asa do Player
			if global_position.x < player.global_position.x - 10.0:
				current_state = State.CHASING

		State.CHASING:
			# Corre para a direita com velocidade extra para tentar alcançar a nave
			movement_vector.x = speed + camera_scroll_speed
			shoot_timer.paused = true
			sprite.play("Walk")
			
			# TRANSIÇÃO: Assim que recuperar o atraso e passar o Player, volta a plantar-se no chão
			if global_position.x >= player.global_position.x + 40.0:
				current_state = State.STATIONARY

	# --- PASSO 2: ORIENTAÇÃO HORIZONTAL (Olhar sempre para o Player) ---
	if global_position.x > player.global_position.x:
		sprite.flip_h = true
		if crosshair.position.x > 0:
			crosshair.position.x *= -1
	else:
		sprite.flip_h = false
		if crosshair.position.x < 0:
			crosshair.position.x *= -1
		
	# Aplica o movimento final livre de loops e conflitos
	global_position += movement_vector * delta


func _on_shoot_timer_timeout() -> void:
	if death or !player: 
		return
		
	var p = projectile.instantiate() as ProjectileEnemy
	camera.add_child(p)
	p.global_position = crosshair.global_position
	p.setDirection()

func die() -> void:
	$CollisionShape2D.set_deferred("disabled", true)
	AudioManager.play_sfx_enemyDeath()
	print("e matou")
	death = true
	sprite.play("Die")

func _on_visible_on_screen_notifier_2d_screen_exited() -> void:
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
	
