extends Area2D
class_name ProjectileEnemy

@export var speed: float = 40.0
var direction: Vector2 = Vector2.ZERO
@export var max_miss: float = 10.0 # valor que a bala pode errar o player, pois no jogo ela é imprecisa

@onready var player: CharacterBody2D = get_tree().get_first_node_in_group("Player") as CharacterBody2D

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	GlobalVars.KillAllProjectiles.connect(die)
	setDirection()

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	position += direction * speed * delta
	
func setDirection() -> void:
	if player:

		var target_position: Vector2 = player.position
		var miss: float = randf_range(0.0, max_miss) # parte do codigo que aplica a margem de erro ao tiro
		target_position.x += miss
		direction = position.direction_to(target_position)


func _on_visible_on_screen_notifier_2d_screen_exited() -> void:
	print("projetil inimigo saiu de tela")
	queue_free()

func die() -> void:
	queue_free()

func _on_body_entered(body: Node2D) -> void:
	if body.is_in_group("Player"):
		body.takeHit()
		die()

func _on_area_entered(area: Area2D) -> void:
	if area.is_in_group("Missile Detector"):
		die()
