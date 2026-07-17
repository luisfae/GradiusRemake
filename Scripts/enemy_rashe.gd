extends Area2D
class_name Rashe

enum State {LAUNCH, GOLEFT}
var current_state: State = State.LAUNCH

@onready var sprite = $AnimatedSprite2D
@export var speed: float = 70.0
@export var health: int = 1

var dropUpgrade: bool = false
var death: bool = false
var points: int = 100
var shoot_timer: Timer
var goLeft: bool = false
var upsideDown: float = -1.0

@onready var player: CharacterBody2D = get_tree().get_first_node_in_group("Player") as CharacterBody2D
var movement_vector: Vector2 = Vector2.ZERO

func _ready() -> void:
	shoot_timer = Timer.new()
	#shoot_timer.wait_time = 2.0
	shoot_timer.timeout.connect(canGoLeft)
	add_child(shoot_timer)
	shoot_timer.start(0.3)
	if global_position.y < 120:
		upsideDown = 1.0

func _physics_process(delta: float) -> void:
	GlobalVars.KillAllEnemies.connect(erase)
	if death:
		return
	match current_state:
		State.LAUNCH:
			movement_vector.x = 0
			movement_vector.y = speed * upsideDown
			
			if player and is_instance_valid(player):
				if upsideDown < 0:
					if global_position.y <= (player.global_position.y - 2) and goLeft:
						#global_position.y = player.global_position.y - 5
						current_state = State.GOLEFT
				else:
					if global_position.y >= (player.global_position.y - 2) and goLeft:
						#global_position.y = player.global_position.y - 5
						current_state = State.GOLEFT
			else:
				if goLeft:
					current_state = State.GOLEFT

		State.GOLEFT:
			movement_vector.x = -speed * 1.5
			movement_vector.y = 0

	global_position += movement_vector * delta

func canGoLeft() -> void:
	goLeft = true

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
