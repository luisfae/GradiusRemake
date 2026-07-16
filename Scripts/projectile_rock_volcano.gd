extends Area2D
class_name Projectile_Rock_Volcano
@export var gravity_force: float = 980.0
@export var min_apex_height: float = 60.0
@export var max_apex_height: float = 120.0
@export var min_distance: float = 80.0
@export var max_distance: float = 240.0
const LIFETIME: float = 1.0
@export var points: int = 100

@onready var sprite: AnimatedSprite2D = $AnimatedSprite2D

var spawn_point: Vector2
var target_point: Vector2
var velocity: Vector2 = Vector2.ZERO
var elapsed: float = 0.0
var is_flying: bool = false

func _ready() -> void:
	spawn_point = global_position
	_pick_target_and_launch()

func _pick_target_and_launch() -> void:
	var direction := 1 if randi() % 2 == 0 else -1
	var distance := randf_range(min_distance, max_distance)
	target_point = spawn_point + Vector2(direction * distance, 0)

	var apex_height := randf_range(min_apex_height, max_apex_height)
	var flight_time := 2.0 * sqrt(2.0 * apex_height / gravity_force)

	velocity.y = -sqrt(2.0 * gravity_force * apex_height)
	velocity.x = (target_point.x - spawn_point.x) / flight_time

	elapsed = 0.0
	is_flying = true

func _process(delta: float) -> void:
	if not is_flying:
		return

	elapsed += delta
	velocity.y += gravity * delta
	global_position += velocity * delta

	if elapsed >= LIFETIME:
		_land()

func _land() -> void:
	is_flying = false
	velocity = Vector2.ZERO
	queue_free()

func die():
	is_flying = false
	sprite.play("death")
	sprite.animation_finished.connect(queue_free, CONNECT_ONE_SHOT)
	givePoints()

func givePoints():
	GlobalVars.receiveScore(points)
	
func _on_area_entered(area: Area2D) -> void:
	if area.is_in_group("Missile Detector"):
		die()
	if area.is_in_group("Player Projectiles"):
		die()


func _on_body_entered(body: Node2D) -> void:
	if body.is_in_group("Player"):
		body.takeHit()
		die()
