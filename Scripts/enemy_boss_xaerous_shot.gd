extends Node2D
class_name Boss_Shot
@onready var speed := 300.0
@onready var shot1 := $Shot1
@onready var shot2 := $Shot2
@onready var shot3 := $Shot3
@onready var shot4 := $Shot4

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
		shot1.queue_free()


func _on_shot_2_body_entered(body: Node2D) -> void:
	if body.is_in_group("Player"):
		body.takeHit()
		shot2.queue_free()


func _on_shot_3_body_entered(body: Node2D) -> void:
	if body.is_in_group("Player"):
		body.takeHit()
		shot3.queue_free()


func _on_shot_4_body_entered(body: Node2D) -> void:
	if body.is_in_group("Player"):
		body.takeHit()
		shot4.queue_free()

func _on_timer_timeout() -> void:
	queue_free()
