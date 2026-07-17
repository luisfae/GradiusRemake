extends Area2D
class_name Dagoom

@export var health: int = 5

var dropUpgrade: bool = false
var death: bool = false
var points: int = 1000
var shoot_timer: Timer
var numberSpawned: int = 0

@onready var sprite = $AnimatedSprite2D
@onready var ray_floor: RayCast2D = $RayCastFloor
@onready var player: Player = get_tree().get_first_node_in_group("Player") as CharacterBody2D
@onready var satellite = preload("res://Scenes/enemy_rashe.tscn")

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	GlobalVars.KillAllEnemies.connect(erase)
	ray_floor.force_raycast_update()
	if ray_floor.is_colliding():
		print("detectou chão")
		# cola no chao
		var sprite_altura = sprite.get_sprite_frames().get_frame_texture(sprite.animation, sprite.frame).get_size().y
		var metade_altura = sprite_altura / 2.0
		global_position.y = ray_floor.get_collision_point().y - (metade_altura)
	else:
		ray_floor.target_position.y *= -1
		ray_floor.force_raycast_update()
		if ray_floor.is_colliding():
			sprite.flip_v = true
			var sprite_altura = sprite.get_sprite_frames().get_frame_texture(sprite.animation, sprite.frame).get_size().y
			var metade_altura = sprite_altura / 2.0
			global_position.y = ray_floor.get_collision_point().y - (-metade_altura)
			
	
	shoot_timer = Timer.new()
	#shoot_timer.wait_time = 2.0
	shoot_timer.timeout.connect(_on_spawn_timer_timeout)
	add_child(shoot_timer)
	shoot_timer.start(1.0)


func _on_spawn_timer_timeout() -> void:
	if death or not player:
		return
	
	if numberSpawned < 8:
		numberSpawned += 1
		var e = satellite.instantiate() as Rashe
		e.position = global_position
		get_tree().current_scene.call_deferred("add_child", e)
		print("O timer disparou! Hora de criar o satelite.")
	if numberSpawned < 4:
		shoot_timer.start(0.3)
	elif numberSpawned == 4:
		shoot_timer.start(1.0)
	elif numberSpawned < 9:
		shoot_timer.start(0.3)
	else:
		pass


func setDropUpgrade() -> void:
	dropUpgrade = true

func die() -> void:
	$CollisionShape2D.set_deferred("disabled", true)
	AudioManager.play_sfx_enemyDeath()
	print("e matou")
	death = true
	sprite.play("Die")

func _on_animated_sprite_2d_animation_finished() -> void:
	if sprite.animation == "Die":
		if dropUpgrade:
			GlobalVars.createUpgrade(global_position)
		queue_free()

func _on_visible_on_screen_notifier_2d_screen_exited() -> void:
	print("saiu de tela")
	queue_free()

func _on_area_entered(area: Area2D) -> void:
	if area.is_in_group("Player Projectiles"):
		area.die()
		takeHit()

func _on_body_entered(body: Node2D) -> void:
	if body.is_in_group("Player"):
		if health > 1:
			body.die()
		else:
			body.takeHit()
			if body.isShieldUp():
				takeHit()

func givePoints() -> void:
	GlobalVars.receiveScore(points)
	
func setPoints(points_: int) -> void:
	points = points_
	
func takeHit() -> void:
	health -= 1
	if health < 3:
		sprite.play("Damaged")
	if health < 1:
		die()
		givePoints()
	
func erase() -> void:
	queue_free()
