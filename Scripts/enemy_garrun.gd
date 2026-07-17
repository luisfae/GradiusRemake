extends Area2D
class_name Garrun

# Movement configuration
@export var speed: float = 50.0        # velocidade em X q ele vai pra <-
@export var rangeOfMotion: float = 15.0    # altura em pixels do arco q ele faz
@export var frequency: float = 4.0     # rapidez q ele faz em Y pra /\ e pra \/
@export var health: int = 1

@onready var sprite = $AnimatedSprite2D

var dropUpgrade: bool = false
var death: bool = false
var points: int = 100

# variaveis de controle
var time_passed: float = 0.0
var spawn_y: float = 0.0

func _ready() -> void:
	GlobalVars.KillAllEnemies.connect(erase)
	# seta o spawn pra posição inicial, pra ir pra cima e pra baixo em ralação a ela
	spawn_y = global_position.y

func _physics_process(delta: float) -> void:
	if !death:
		# pega o tempo q passou, necessario pra calcular o sin
		time_passed += delta
		
		global_position.x -= speed * delta
		
		# calcula o vai e vem usando sin e o tempo q passou, e a amplitude q é o range
		var wave_offset = sin(time_passed * frequency) * rangeOfMotion
		global_position.y = spawn_y + wave_offset

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
