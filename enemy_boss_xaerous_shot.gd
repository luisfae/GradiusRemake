extends Node2D
class_name Boss_Shot
@onready var speed := 300.0

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass

func _physics_process(delta: float) -> void:
	position -= transform.x * speed * delta

func _on_shot_1_body_entered(body: Node2D) -> void:
	if body.is_in_group("Player"):
		body.takeHit()


func _on_shot_2_body_entered(body: Node2D) -> void:
	if body.is_in_group("Player"):
		body.takeHit()


func _on_shot_3_body_entered(body: Node2D) -> void:
	if body.is_in_group("Player"):
		body.takeHit()


func _on_shot_4_body_entered(body: Node2D) -> void:
	if body.is_in_group("Player"):
		body.takeHit()
