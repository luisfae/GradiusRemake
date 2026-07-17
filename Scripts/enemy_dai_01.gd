extends Area2D
class_name Dai

@export var fire_rate: float = 3 # aqui define o tempo pra atirar

var death: bool = false
@export var dropUpgrade: bool = false
@export var health: int = 1
var shoot_timer: Timer
var points: int = 100

@onready var projectile = preload("res://Scenes/projectile_enemy.tscn")
@onready var sprite = $AnimatedSprite2D
@onready var player: Player = get_tree().get_first_node_in_group("Player") as CharacterBody2D
@onready var aimUp = $Crosshair_Up
@onready var aimMid = $Crosshair_Mid
@onready var aimDown = $Crosshair_Down
@onready var camera: Camera2D = get_viewport().get_camera_2d()
@onready var ray_down: RayCast2D = $RayCastDown
@onready var ray_up: RayCast2D = $RayCastUp

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	GlobalVars.KillAllEnemies.connect(erase)
	ray_down.force_raycast_update()
	ray_up.force_raycast_update()
	if ray_down.is_colliding():
		print("detectou chão")
		sprite.flip_v = false
		# cola no chao
		var sprite_altura = sprite.get_sprite_frames().get_frame_texture(sprite.animation, sprite.frame).get_size().y
		var metade_altura = sprite_altura / 2.0
		global_position.y = ray_down.get_collision_point().y - (metade_altura) - 2 # hard coded 1 pra n ficar colado
	elif ray_up.is_colliding():
		print("detectou teto")
		sprite.flip_v = true
		aimUp.position.y *= -1
		aimMid.position.y *= -1
		aimDown.position.y *= -1
		# cola no chao
		var sprite_altura = sprite.get_sprite_frames().get_frame_texture(sprite.animation, sprite.frame).get_size().y
		var metade_altura = sprite_altura / 2.0
		global_position.y = ray_up.get_collision_point().y - (-metade_altura) + 2 # msm hard coded 1
	else:
		pass
	
	shoot_timer = Timer.new()
	shoot_timer.wait_time = fire_rate
	shoot_timer.autostart = true
	shoot_timer.timeout.connect(_on_shoot_timer_timeout)
	add_child(shoot_timer)

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta: float) -> void:
	animate()

func animate():
	if !death:
		if !player or !is_instance_valid(player):
			return
		if global_position.x > player.global_position.x:
			sprite.flip_h = true
			if aimUp.position.x > 0:
				aimUp.position.x *= -1
				aimMid.position.x *= -1
				aimDown.position.x *= -1
		else:
			sprite.flip_h = false
			if aimUp.position.x < 0:
				aimUp.position.x *= -1
				aimMid.position.x *= -1
				aimDown.position.x *= -1
		
		var diff_x = abs(player.global_position.x - global_position.x)
		var diff_y = player.global_position.y - global_position.y
		var absolute_angle = abs(rad_to_deg(atan2(diff_y, diff_x)))
		
		if absolute_angle <= 30:
			sprite.play("Aim_Down")
		elif absolute_angle <= 60:
			sprite.play("Aim_Straight")
		else:
			sprite.play("Aim_Up")

func _on_shoot_timer_timeout() -> void:
	if death or not player:
		return
		
	var p = projectile.instantiate() as ProjectileEnemy
	camera.add_child(p)
	if sprite.animation == "Aim_Up":
		p.global_position = aimUp.global_position
	elif sprite.animation == "Aim_Straight":
		p.global_position = aimMid.global_position
	elif sprite.animation == "Aim_Down":
		p.global_position = aimDown.global_position
	p.setDirection()
	print("O timer disparou! Hora de criar o projétil.")

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
		body.takeHit()
		if body.isShieldUp():
			takeHit()

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
