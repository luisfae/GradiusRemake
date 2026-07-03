extends Area2D
class_name ProjectileEnemy

@export var speed: float = 40.0
var direction: Vector2 = Vector2.ZERO

@onready var player: CharacterBody2D = get_tree().get_first_node_in_group("Player") as CharacterBody2D

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	setDirection()

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	position += direction * speed * delta
	

func setDirection() -> void:
	if player:
		direction = position.direction_to(player.position)

func _on_visible_on_screen_notifier_2d_screen_exited() -> void:
	print("projetil inimigo saiu de tela")
	queue_free()

func die() -> void:
	queue_free()

func _on_body_entered(body: Node2D) -> void:
	if body.is_in_group("Player"):
		body.takeHit()
		die()
