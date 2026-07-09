extends CharacterBody2D
class_name Player

@export var health: int = 1
@export var speed := 50.0
@onready var sprite = $AnimatedSprite2D
@onready var bullet = preload("res://Scenes/bullet.tscn")
@onready var missile = preload("res://Scenes/missile.tscn")
@onready var laser = preload("res://Scenes/laser.tscn")
@onready var option = preload("res://Scenes/option.tscn")
@onready var shield = self.get_node("Shield")
@onready var alive: bool
@onready var shootTimer: Timer = $ShootTimer
@export var double_fire = false
@export var laser_fire = false
@export var missile_fire = false
var canMissile: Array[bool] = [true, true, true]
var projectilesMyAndOptions: Array[int] = [0, 0, 0]

func _ready():
	alive = true
	GlobalVars.UpgradeSpeed.connect(UpgradeSpeed)
	GlobalVars.UpgradeMissile.connect(UpgradeMissile)
	GlobalVars.UpgradeDouble.connect(UpgradeDouble)
	GlobalVars.UpgradeLaser.connect(UpgradeLaser)
	GlobalVars.UpgradeOption.connect(UpgradeOption)
	GlobalVars.UpgradeShield.connect(UpgradeShield)
	GlobalVars.KonamiCode.connect(KonamiCode)

func get_input():
	var input_dir := Vector2(
		Input.get_axis("left", "right"),
		Input.get_axis("up", "down")
	)
	if input_dir.length() > 1.0:
		input_dir = input_dir.normalized()
	velocity = input_dir * speed
	
	if Input.is_action_just_pressed("r1"):
		speed += 25
		
	if Input.is_action_just_pressed("l1"):
		print("Cheatando getUpgrade")
		GlobalVars.getUpgrade()
	
	var clickedNow = Input.is_action_just_pressed("fire")
	var holdingClick = Input.is_action_pressed("fire")
	if clickedNow: # agora é assim pq o tiro quando segura o botão tem um delay, e se aperta rapido sai rapido
		shootTimer.start()
		shootWeapons()
	elif holdingClick and shootTimer.is_stopped():
		shootTimer.start()
		shootWeapons()
	
	if Input.is_action_just_pressed("applyUpgrade"):
		print("Chamando Apply Upgrade")
		GlobalVars.applyUpgrade()

func _physics_process(_delta: float) -> void:
	if !alive:
		return
	get_input()
	animate()
	move_and_slide()
	# codigo teste para limitar a nave de sair da tela
	var half_screen := get_viewport_rect().size / 2.0
	var padding := Vector2(20, 12) # esse 20 eh hard coded, se fosse o tamanho da nave real q eh 26, ela nao vai tao pra < quanto no jogo original
	position.x = clampf(position.x, -half_screen.x + padding.x, half_screen.x - padding.x)
	position.y = clampf(position.y, -102 + padding.y, 98 - padding.y)
	#print(half_screen)

func shootWeapons() -> void:
	print("shoot")
		
	# array pra contar se tem options seguindo já
	var active_followers: Array[Node2D] = []
	var camera_node = get_parent()
	if camera_node:
		for child in camera_node.get_children():
			if child.name.begins_with("Option") and is_instance_valid(child) and child.is_inside_tree():
				active_followers.append(child as Node2D)
	
	if laser_fire:
		if projectilesMyAndOptions[0] < 2:
			AudioManager.play_sfx_playerLaser()
			var l = laser.instantiate() as Laser
			l.position = global_position
			l.position.y -= 5
			l.position.x += 17
			owner.add_child(l)
			l.MyFatherIs.connect(fatherOfMyProjectiles)
			projectilesMyAndOptions[0] += 1
		
		# tiro do option
		for i in range(active_followers.size()):
			if projectilesMyAndOptions[1 + i] < 2:
				var follower = active_followers[i]
				var l_opt = laser.instantiate() as Laser
				l_opt.position = follower.global_position
				l_opt.position.x += 12
				l_opt.father = 1 + i
				owner.add_child(l_opt)
				l_opt.MyFatherIs.connect(fatherOfMyProjectiles)
				projectilesMyAndOptions[1 + i] += 1
	else:
		if projectilesMyAndOptions[0] < 2:
			AudioManager.play_sfx_playerFire()
			var b = bullet.instantiate() as Bullet
			b.position = global_position
			b.position.y -= 5
			b.position.x += 17
			owner.add_child(b)
			b.MyFatherIs.connect(fatherOfMyProjectiles)
			projectilesMyAndOptions[0] += 1
		
		# tiro do option
		for i in range(active_followers.size()):
			if projectilesMyAndOptions[1 + i] < 2:
				var follower = active_followers[i]
				var b_opt = bullet.instantiate() as Bullet
				b_opt.position = follower.global_position
				b_opt.position.x += 12
				b_opt.father = 1 + i
				owner.add_child(b_opt)
				b_opt.MyFatherIs.connect(fatherOfMyProjectiles)
				projectilesMyAndOptions[1 + i] += 1
	
	if double_fire:
		var b2 = bullet.instantiate() as Bullet
		b2.position = global_position
		b2.position.y -= 10
		b2.position.x += 17
		b2.set_up()
		owner.add_child(b2)
		
		# tiro do option
		for i in range(active_followers.size()):
			var follower = active_followers[i]
			var b2_opt = bullet.instantiate() as Bullet
			b2_opt.position = follower.global_position
			b2_opt.position.y -= 7
			b2_opt.position.x += 12
			b2_opt.set_up()
			owner.add_child(b2_opt)
	
	if missile_fire:
		if canMissile[0]:
			canMissile[0] = false
			var m = missile.instantiate() as Missile
			m.position = global_position
			m.position.x += 4
			owner.add_child(m)
			m.MyFatherIs.connect(fatherOfMyMissile)
		
		# missile do option
		for i in range(active_followers.size()):
			var follower = active_followers[i]
			if canMissile[1 + i]:
				canMissile[1 + i] = false
				var m_opt = missile.instantiate() as Missile
				m_opt.position = follower.global_position
				m_opt.position.x += 4
				m_opt.father = 1 + i
				owner.add_child(m_opt)
				m_opt.MyFatherIs.connect(fatherOfMyMissile)

func takeHit():
	health -= 1
	if health < 1:
		die()
	elif health < 2:
		shield.deactivate()
	elif health < 4:
		if(shield.high):
			shield.setLow()

func die():
	$CollisionShape2D.set_deferred("disabled", true)
	AudioManager.play_sfx_playerDeath()
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
	
func UpgradeSpeed() -> void:
	AudioManager.play_sfx_upgradeApply()
	speed += 25

func UpgradeMissile() -> void:
	if !missile_fire:
		missile_fire = true
		AudioManager.play_sfx_upgradeApply()
	
func UpgradeDouble() -> void:
	if !double_fire:
		double_fire = true
		laser_fire = false
		AudioManager.play_sfx_upgradeApply()
	
func UpgradeLaser() -> void:
	if !laser_fire:
		laser_fire = true
		double_fire = false
		AudioManager.play_sfx_upgradeApply()
	
func UpgradeOption() -> void:
	var camera_node = get_parent()
	if not camera_node:
		return
		
	var existing_options: Array[Node2D] = []
	for child in camera_node.get_children():
		if child.name.begins_with("Option") and is_instance_valid(child):
			existing_options.append(child as Node2D)
			
	if existing_options.size() >= 2:
		print("Naum cabe mais optiones")
		return
		
	var new_option = option.instantiate()
	AudioManager.play_sfx_upgradeApply()
	if existing_options.size() == 0:
		new_option.target_node = self
		new_option.name = "Option1"
	else:
		new_option.target_node = existing_options[0]
		new_option.name = "Option2"
		
	camera_node.add_child(new_option)
	new_option.position = get_parent().to_local(new_option.target_node.global_position)
	
	print("Nova option criada: ", new_option.name)
	
func UpgradeShield() -> void:
	if health < 6:
		shield.activate()
		health = 6
		AudioManager.play_sfx_upgradeApply()

func _on_animated_sprite_2d_animation_finished() -> void:
	if sprite.animation == "Death":
		queue_free()

func KonamiCode() -> void:
	UpgradeSpeed() # nao sei quantos speed upgrades o cheat dá, lembro de algum video dizer
	UpgradeMissile()
	UpgradeOption()
	UpgradeOption()
	UpgradeShield()

func fatherOfMyMissile(father_: int) -> void:
	canMissile[father_] = true

func fatherOfMyProjectiles(father_: int) -> void:
	projectilesMyAndOptions[father_] -= 1

func isShieldUp() -> bool:
	if health > 1:
		return true
	else:
		return false
