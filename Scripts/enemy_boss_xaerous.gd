extends Node2D
class_name Xaerous

enum State {UP, DOWN}
var current_state: State = State.UP
@export var speed: float = 80.0
var movement_vector: Vector2 = Vector2.ZERO
var camera: Camera2D = null
var points: int = 10000
var seconds_counter: int
var alive: bool = true
var health: int = 1000
var shield: int = 500
@onready var main_scene = get_tree().current_scene
@onready var screen_height: float = get_viewport().get_visible_rect().size.y
@onready var action_timer: Timer = $Timer
@onready var change_direction: bool = false
@onready var core = $Core
@onready var shield1 = $Shield_1
@onready var shield2 = $Shield_2
@onready var shield3 = $Shield_3
@onready var shield4 = $Shield_4
@onready var ray_left: RayCast2D = $RayCastLeft
@onready var deathAnimation: AnimatedSprite2D = $DeathAnimation
@onready var boss_shot = preload("res://Scenes/enemy_boss_xaerous_shot.tscn")
@onready var player: Player = get_tree().get_first_node_in_group("Player") as CharacterBody2D

const pos_x_initial : float = 3798.0
@export var half_sprite_width: float = 24.0

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	#action_timer.autostart = true
	camera = get_viewport().get_camera_2d()
	#seconds_counter = 0
	set_physics_process(false)
	GlobalVars.WakeBoss.connect(wakeUpBoss)
	GlobalVars.KillAllEnemies.connect(erase)

func _physics_process(delta: float) -> void:
	if !camera or !alive:
		return
	ray_left.force_raycast_update()
	if ray_left.is_colliding():
		change_direction = true
	match current_state:
		State.UP:
			movement_vector.x =  0
			movement_vector.y = -speed
			
			var camera_top_edge = camera.global_position.y - (screen_height / 2.0)
			var target_turn_y = camera_top_edge + (screen_height * 0.10)
			
			if global_position.y <= target_turn_y:
				movement_vector.y = 0
				change_direction = true
		State.DOWN:
			movement_vector.x =  0
			movement_vector.y = speed
			
			var camera_bot_edge = camera.global_position.y + (screen_height / 2.0)
			var target_turn_y = camera_bot_edge - (screen_height * 0.22)
			
			if global_position.y >= target_turn_y:
				movement_vector.y = 0
				change_direction = true
			
	if is_instance_valid(player):
		var screen_width: float = get_viewport().get_visible_rect().size.x
		var camera_right_edge: float = camera.global_position.x + (screen_width / 2.0)
		var max_right_pos: float = camera_right_edge - half_sprite_width

		if player.global_position.x > global_position.x:
			if global_position.x < max_right_pos:
				movement_vector.x = speed
			else:
				global_position.x = max_right_pos
				movement_vector.x = 0
		else:
			if global_position.x > pos_x_initial:
				movement_vector.x = -speed
			else:
				global_position.x = pos_x_initial
				movement_vector.x = 0
	else:
		movement_vector.x = 0
	
	global_position += movement_vector * delta

func wakeUpBoss() -> void:
	set_physics_process(true)
	action_timer.autostart = true
	action_timer.start()
	camera = get_viewport().get_camera_2d()
	seconds_counter = 0

func fire():
	var b = boss_shot.instantiate() as Boss_Shot
	b.position = global_position
	#b.position.x += 20
	main_scene.add_child(b)

func takeHit(shellHit : bool, shotDamage: int = 25):
	if shellHit:
		health -= shotDamage
	else:
		shield -= shotDamage
	if health <= 0 or shield <= 0:
		die()
	handleShieldGraphics()

func handleShieldGraphics():
	if !alive:
		return
	if shield <= 300:
		if shield1:
			shield1.queue_free()
	if shield <= 200:
		if shield2:
			shield2.queue_free()
	if shield <= 150:
		if shield3:
			shield3.queue_free()
	if shield <= 100:
		if shield4:
			shield4.queue_free()

func die(killed : bool = true):
	if !alive:
		return
	alive = false
	for child in get_children():
		if child is not Timer:
			child.visible = false
	deathAnimation.visible = true
	deathAnimation.play("death")
	deathAnimation.animation_finished.connect(onDeathAnimationEnd)
	if killed:
		givePoints()

func onDeathAnimationEnd():
	queue_free()
	GlobalVars.endBossEvent()

func givePoints() -> void:
	GlobalVars.receiveScore(points)
	
# COLISÕES DO PLAYER COM AS DIFERENTES PARTES DO BOSS
func _on_ship_top_body_entered(body: Node2D) -> void:
	if body.is_in_group("Player"):
		#body.takeHit()
		body.die()


func _on_ship_bottom_body_entered(body: Node2D) -> void:
	if body.is_in_group("Player"):
		#body.takeHit()
		body.die()


func _on_shield_1_body_entered(body: Node2D) -> void:
	if body.is_in_group("Player"):
		#body.takeHit()
		body.die()


func _on_shield_2_body_entered(body: Node2D) -> void:
	if body.is_in_group("Player"):
		#body.takeHit()
		body.die()


func _on_shield_3_body_entered(body: Node2D) -> void:
	if body.is_in_group("Player"):
		#body.takeHit()
		body.die()


func _on_shield_4_body_entered(body: Node2D) -> void:
	if body.is_in_group("Player"):
		#body.takeHit()
		body.die()



# COLISÕES DOS TIROS DO PLAYER COM AS DIFERENTES PARTES DO BOSS
func _on_ship_top_area_entered(area: Area2D) -> void:
	if area.is_in_group("Player Projectiles"):
		area.die()
		takeHit(true)


func _on_ship_bottom_area_entered(area: Area2D) -> void:
	if area.is_in_group("Player Projectiles"):
		area.die()
		takeHit(true)


func _on_shield_1_area_entered(area: Area2D) -> void:
	if area.is_in_group("Player Projectiles"):
		area.die()
		takeHit(false)


func _on_shield_2_area_entered(area: Area2D) -> void:
	if area.is_in_group("Player Projectiles"):
		area.die()
		takeHit(false)


func _on_shield_3_area_entered(area: Area2D) -> void:
	if area.is_in_group("Player Projectiles"):
		area.die()
		takeHit(false)


func _on_shield_4_area_entered(area: Area2D) -> void:
	if area.is_in_group("Player Projectiles"):
		area.die()
		takeHit(false)


func _on_core_2_area_entered(area: Area2D) -> void:
	if area.is_in_group("Player Projectiles"):
		area.die()
		takeHit(false)

func _on_timer_timeout() -> void:
	if !alive:
		return
	fire()
	if change_direction:
		if current_state == State.UP:
			current_state = State.DOWN
		else:
			current_state = State.UP
		change_direction = false
	seconds_counter += 1
	if seconds_counter >= 32:
		die(false)
	elif seconds_counter >= 20:
		core.visible = false
	elif seconds_counter >= 3:
		core.visible = true

func erase() -> void:
	queue_free()
