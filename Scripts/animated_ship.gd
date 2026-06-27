extends CharacterBody2D

class_name Player

@export var speed := 50.0
@onready var sprite = $AnimatedSprite2D
#@export var bullet: PackedScene
@onready var bullet = preload("res://Scenes/bullet.tscn")
@onready var missile = preload("res://Scenes/missile.tscn")
@onready var laser = preload("res://Scenes/laser.tscn")
@onready var alive: bool
@export var double_fire = false
@export var laser_fire = false
@export var missile_fire = false

func _ready():
	alive = true
	GlobalVars.UpgradeSpeed.connect(UpgradeSpeed)
	GlobalVars.UpgradeMissile.connect(UpgradeMissile)
	GlobalVars.UpgradeDouble.connect(UpgradeDouble)
	GlobalVars.UpgradeLaser.connect(UpgradeLaser)
	GlobalVars.UpgradeOption.connect(UpgradeOption)
	GlobalVars.UpgradeShield.connect(UpgradeShield)

func get_input():
	var input_directionX := Input.get_axis("left", "right")
	velocity.x = input_directionX * speed
	
	var input_directionY := Input.get_axis("up", "down")
	velocity.y = input_directionY * speed
	
	if Input.is_action_just_pressed("r1"):
		speed += 25
		
	if Input.is_action_just_pressed("l1"):
		print("Cheatando getUpgrade")
		GlobalVars.getUpgrade()
	
	if Input.is_action_just_pressed("fire"):
		print("shoot")
		if laser_fire:
			var l = laser.instantiate() as Laser
			l.position = global_position # tem q usar a global_pos pq a nave agr eh filha da camera
			l.position.y -= 5 # numero hard coded pra sair do meio da nave
			l.position.x += 17
			owner.add_child(l)
		else:		
			var b = bullet.instantiate() as Bullet
			b.position = global_position # tem q usar a global_pos pq a nave agr eh filha da camera
			b.position.y -= 5 # numero hard coded pra sair do meio da nave
			b.position.x += 17
			owner.add_child(b)
		
		if double_fire:
			var b2 = bullet.instantiate() as Bullet
			b2.position = global_position # tem q usar a global_pos pq a nave agr eh filha da camera
			b2.position.y -= 10 # numero hard coded pra sair do meio da nave
			b2.position.x += 17
			b2.set_up()
			owner.add_child(b2)
		
		if missile_fire:
			var m = missile.instantiate() as Missile
			m.position = global_position # tem q usar a global_pos pq a nave agr eh filha da camera
			m.position.x += 4
			owner.add_child(m)
	
	if Input.is_action_just_pressed("applyUpgrade"):
		print("Chamando Apply Upgrade")
		GlobalVars.applyUpgrade()


func _physics_process(delta: float) -> void:
	if !alive:
		return
	get_input()
	animate()
	move_and_slide()
	
	# Codigo teste para limitar a nave de sair da tela
	var half_screen := get_viewport_rect().size / 2.0
	var padding := Vector2(20, 12) # esse 20 eh hard coded, se fosse o tamanho da nave real q eh 26, ela nao vai tao pra < quanto no jogo original
	position.x = clampf(position.x, -half_screen.x + padding.x, half_screen.x - padding.x)
	position.y = clampf(position.y, -102 + padding.y, 98 - padding.y)
	#print(half_screen)

func die():
	$CollisionShape2D.disabled = true
	alive = false
	print("e morreu")
	sprite.play("Death")
	
func animate():
	if !alive:
		return
	if velocity.y < 0:
		sprite.play("Up")
	elif velocity.y > 0:
		sprite.play("Down")
	else:
		sprite.play("Standard")

func receiveUpgrade(upgrade: int) -> void:
	pass
	
func UpgradeSpeed() -> void:
	speed += 25

func UpgradeMissile() -> void:
	missile_fire = true
	
func UpgradeDouble() -> void:
	double_fire = true
	laser_fire = false
	
func UpgradeLaser() -> void:
	laser_fire = true
	double_fire = false
	
func UpgradeOption() -> void:
	pass
	
func UpgradeShield() -> void:
	pass


func _on_animated_sprite_2d_animation_finished() -> void:
	if sprite.animation == "Death":
		queue_free()
