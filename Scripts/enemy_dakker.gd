extends Area2D
class_name Dakker

enum State { STATIONED, MOVING, EXITING }
var current_state: State = State.MOVING # Nasce a mover-se para entrar no ecrã

# configs pra ajustar
@export var speed: float = 70.0
@export var health: int = 1
@export var points: int = 100

var max_stationed_uses: int = 0       # sorteado no _ready (3 a 5)
var stationed_counter: int = 0       # quantas vezes já sentou
var total_shots_fired: int = 0       # limite de 3 tiros na vida útil

var target_pos_x: float = 0.0        # alvo X para onde ele está a caminhar
var stationed_duration: float = 0.0  # quanto tempo vai ficar parado (0.5 a 2.5s)
var stationed_timer: float = 0.0     # cronometro do estado parado
var shot_trigger_time: float = -1.0  # o milissegundo exato (metade do tempo) para disparar
var already_shot_this_cycle: bool = false

# constantes importantes pra definir o tempo e a distancia que o dakker senta e se move
const stationed_duration_min: float = 0.8
const stationed_duration_max: float = 2.5
const offset_aleatorio_min: float = 30.0
const offset_aleatorio_max: float = 150.0

var dropUpgrade: bool = false
var death: bool = false
var movement_vector: Vector2 = Vector2.ZERO
var invert_y: float = 1.0

@onready var projectile = preload("res://Scenes/projectile_enemy.tscn")
@onready var sprite = $AnimatedSprite2D
@onready var player: CharacterBody2D = get_tree().get_first_node_in_group("Player") as CharacterBody2D
@onready var crosshair = $Crosshair
@onready var camera: Camera2D = get_viewport().get_camera_2d()

@onready var ray_down: RayCast2D = $RayCastDown
@onready var ray_up: RayCast2D = $RayCastUp
@onready var ray_floor: RayCast2D
@onready var ray_left: RayCast2D = $RayCastLeft
@onready var ray_right: RayCast2D = $RayCastRight
@onready var screen_width: float = get_viewport().get_visible_rect().size.x

func _ready() -> void:
	GlobalVars.KillAllEnemies.connect(erase)
	GlobalVars.HitAllEnemies.connect(die)
	if !player: return
	
	max_stationed_uses = randi_range(3, 5)
	
	ray_down.force_raycast_update()
	ray_up.force_raycast_update()
	
	if ray_down.is_colliding():
		sprite.flip_v = false
		ray_floor = ray_down
		invert_y = 1.0
		var sprite_altura = sprite.get_sprite_frames().get_frame_texture(sprite.animation, sprite.frame).get_size().y
		var metade_altura = sprite_altura / 2.0
		global_position.y = ray_down.get_collision_point().y - (metade_altura) - 3
	elif ray_up.is_colliding():
		sprite.flip_v = true
		crosshair.position.y *= -1
		ray_left.position.y *= -1
		ray_right.position.y *= -1
		ray_floor = ray_up
		invert_y = -1.0
		var sprite_altura = sprite.get_sprite_frames().get_frame_texture(sprite.animation, sprite.frame).get_size().y
		var metade_altura = sprite_altura / 2.0
		global_position.y = ray_up.get_collision_point().y - (-metade_altura) + 3
	else:
		invert_y = 1.0
		ray_floor = ray_down

	calcular_proximo_alvo_moving()

func _physics_process(delta: float) -> void:
	if !player or !is_instance_valid(player) or death: return
	
	ray_left.force_raycast_update()
	ray_right.force_raycast_update()
	if ray_floor: ray_floor.force_raycast_update()

	movement_vector = Vector2.ZERO
	var direction_x = 0.0

	var camera_left_edge = camera.global_position.x - (screen_width / 2.0)
	var camera_right_edge = camera.global_position.x + (screen_width / 2.0)

	match current_state:
		
		State.MOVING:
			sprite.play("Walk")
			if global_position.x <= camera_left_edge + 20.0:
				avaliar_proximo_estado_apos_levantar()
			
			if global_position.x > target_pos_x + 4.0:
				direction_x = -1.0
			elif global_position.x < target_pos_x - 4.0:
				direction_x = 1.0
				if global_position.x >= camera_right_edge - 15.0:
					entrar_estado_stationed()
			else:
				entrar_estado_stationed()
	
		State.STATIONED:
			sprite.play("Still")
			direction_x = 0.0
			stationed_timer += delta
			
			if shot_trigger_time > 0.0 and not already_shot_this_cycle:
				if stationed_timer >= shot_trigger_time:
					disparar_projetil()
					total_shots_fired += 1
					already_shot_this_cycle = true
			
			if stationed_timer >= stationed_duration:
				avaliar_proximo_estado_apos_levantar()
	
		State.EXITING:
			sprite.play("Walk")
			direction_x = -1.0
	
	var olhar_para_direita = (direction_x == 1.0) if current_state != State.STATIONED else (player.global_position.x > global_position.x)
	
	if olhar_para_direita:
		sprite.flip_h = false
		if crosshair.position.x < 0:
			crosshair.position.x *= -1
	else:
		sprite.flip_h = true
		if crosshair.position.x > 0:
			crosshair.position.x *= -1
		
	var leteralCollision = false
	
	if direction_x == -1.0 and ray_left.is_colliding():
		movement_vector.x = 0
		movement_vector.y = -speed * invert_y
		leteralCollision = true
	elif direction_x == 1.0 and ray_right.is_colliding():
		movement_vector.x = 0
		movement_vector.y = -speed * invert_y
		leteralCollision = true
	
	if not leteralCollision:
		movement_vector.x = direction_x * speed
		if ray_floor and not ray_floor.is_colliding():
			movement_vector.x = 0
			movement_vector.y = speed * invert_y
	
	global_position += movement_vector * delta
	
	if ray_floor and ray_floor.is_colliding() and !leteralCollision:
		var sprite_altura = sprite.get_sprite_frames().get_frame_texture(sprite.animation, sprite.frame).get_size().y
		var metade_altura = sprite_altura / 2.0
		global_position.y = ray_floor.get_collision_point().y - (metade_altura * invert_y) - (3 * invert_y)

	var margem_tolerancia = screen_width / 4.0
	if global_position.x < (camera_left_edge - margem_tolerancia):
		queue_free()

func calcular_proximo_alvo_moving() -> void:
	current_state = State.MOVING
	
	var offset_aleatorio = randf_range(offset_aleatorio_min, offset_aleatorio_max)
	target_pos_x = player.global_position.x + offset_aleatorio
	if (player.global_position.x > global_position.x):
		target_pos_x += player.global_position.x - global_position.x
	

func entrar_estado_stationed() -> void:
	current_state = State.STATIONED
	stationed_counter += 1
	stationed_timer = 0.0
	already_shot_this_cycle = false
	
	# sorteia o tempo de permanência parado (0.5 a 2.5 segundos)
	stationed_duration = randf_range(stationed_duration_min, stationed_duration_max)
	
	# sorteia se vai atirar (50% de chance)
	if randf() <= 0.5:
		# define o disparo exato para a metade do tempo sorteado
		shot_trigger_time = stationed_duration / 2.0
	else:
		shot_trigger_time = -1.0 # nao disparou

func avaliar_proximo_estado_apos_levantar() -> void:
	# 1a condicao - atingiu o numero maximo de sentadas sorteado no ready?
	if stationed_counter >= max_stationed_uses:
		ir_para_exiting()
		
	# 2a condicao - ja disparou 3 tiros no total da sua vida?
	elif total_shots_fired >= 3:
		ir_para_exiting()
		
	# 3a condicao - se estiver muito perto da borda esquerda da tela,
	# em vez de tentar andar para a frente, ele simplesmente ativa a fuga
	elif global_position.x <= (camera.global_position.x - (screen_width / 2.0)) + 30.0:
		ir_para_exiting()
		
	# se nenhuma condicao anterior, calcula o próximo alvo
	else:
		calcular_proximo_alvo_moving()

func ir_para_exiting() -> void:
	print("Dakker a entrar em modo de fuga definitivo (EXITING)")
	current_state = State.EXITING

func disparar_projetil() -> void:
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
	pass

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

func erase() -> void:
	queue_free()
