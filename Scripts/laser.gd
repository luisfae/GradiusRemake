extends Area2D
class_name Laser

@export var speed: float = 1000.0
var father: int = 0

signal MyFatherIs(myFather: int)

func _ready() -> void:
	pass

func _physics_process(delta: float) -> void:
	# Move forward along the local X-axis
	position += transform.x * speed * delta

func setFather(father_: int) -> void:
	father = father_

func _on_visible_on_screen_notifier_2d_screen_exited() -> void:
	print("saiu de tela")
	MyFatherIs.emit(father)
	queue_free()
	
func kill_sprite2d() -> void:
	print("kill")
	if find_child("Sprite2D"):
		$Sprite2D.queue_free()

func die() -> void:
	pass

func _on_body_entered(body: Node2D) -> void:
	if body.is_in_group("Cenario"):
		MyFatherIs.emit(father)
		queue_free()
