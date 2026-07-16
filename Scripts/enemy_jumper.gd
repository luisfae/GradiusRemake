extends Area2D
class_name Jumper

# AQUI MUDA AS VARIAVEIS PRA CONFIGURAR O PULO, PRINCIPALMENTE AS DUAS PRIMEIRAS
@export var jumpDistance: float = 70.0   # distância exata de cada salto em pixels
@export var jumpHeight: float = 50.0     # altura máxima do topo do salto
@export var jumpDuration: float = 1.0    # tempo que o salto demora a ser executado (segundos)
@export var howFarCanGo: float = 120.0    # quao longe pode ir fora da tela

@onready var sprite = $AnimatedSprite2D
@onready var player: CharacterBody2D = get_tree().get_first_node_in_group("Player") as CharacterBody2D
@onready var camera: Camera2D = get_viewport().get_camera_2d()
@onready var screen_width: float = get_viewport().get_visible_rect().size.x
@onready var ray_floor: RayCast2D = $RayCastFloor

@export var health: int = 1
var dropUpgrade: bool = false
var death: bool = false
var points: int = 100

var time_in_jump: float = 0.0
var is_jumping: bool = false
var start_x: float = 0.0
var target_x: float = 0.0
var floor_y: float = 0.0
var direction_x: float = -1.0
var alreadyJumpedRight: bool = false

func _ready() -> void:
	ray_floor.force_raycast_update()
	if ray_floor.is_colliding():
		var sprite_altura = sprite.get_sprite_frames().get_frame_texture(sprite.animation, sprite.frame).get_size().y
		var metade_altura = sprite_altura / 2.0
		global_position.y = ray_floor.get_collision_point().y - (metade_altura) - 1 # hard coded 1 pra n ficar colado
	floor_y = global_position.y

func _physics_process(delta: float) -> void:
	if death or !camera: 
		return

	var camera_left_edge = camera.global_position.x - (screen_width / 0.6)
	var camera_right_edge = camera.global_position.x + (screen_width / 2.0)
	
	# dois estados, não esta pulando ou esta pulando
	if !is_jumping:
		time_in_jump = 0.0
		start_x = global_position.x
		if player:
			if global_position.x > player.global_position.x:
				direction_x = -1.0
				sprite.flip_h = true
			elif !alreadyJumpedRight: # ele só pula 1x pra direita, um pulão
				direction_x = 1.0
				sprite.flip_h = false
				alreadyJumpedRight = true
			else:
				direction_x = -1.0
				sprite.flip_h = true
		else:
			direction_x = -1.0
			sprite.flip_h = true
		if sprite.flip_h:
			target_x = start_x + (direction_x * jumpDistance)
		else:
			target_x = start_x + (direction_x * (jumpDistance * 2)) # aqui é pra fazer o pulão, por enqnt ta o dobro
		target_x = clamp(target_x, camera_left_edge, camera_right_edge)
		is_jumping = true
		
	if is_jumping:
		time_in_jump += delta
		var progress = time_in_jump / jumpDuration
		if progress >= 1.0:
			global_position.x = target_x
			global_position.y = floor_y
			is_jumping = false
		else:
			global_position.x = lerp(start_x, target_x, progress)
			var jump_arc = sin(PI * progress) * jumpHeight
			global_position.y = floor_y - jump_arc
	#if global_position.x < (camera_left_edge - howFarCanGo):
		#queue_free()
		#print("jumper se foi")

func die() -> void:
	$CollisionShape2D.set_deferred("disabled", true)
	AudioManager.play_sfx_enemyDeath()
	print("e matou")
	death = true
	sprite.play("Die")

func _on_visible_on_screen_notifier_2d_screen_exited() -> void:
	if alreadyJumpedRight:
		queue_free()
		print("jumper se foi")

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
		givePoints()
	
