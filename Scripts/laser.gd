extends Area2D
class_name Laser

@export var speed: float = 1000.0

func _ready() -> void:
	pass

func _physics_process(delta: float) -> void:
	# Move forward along the local X-axis
	position += transform.x * speed * delta

func _on_visible_on_screen_notifier_2d_screen_exited() -> void:
	print("saiu de tela")
	queue_free()
	
func kill_sprite2d() -> void:
	print("kill")
	if find_child("Sprite2D"):
		$Sprite2D.queue_free()

#func _on_body_entered(body):
	#if body.is_in_group("Enemies"):
		#body.die()

func _on_area_entered(area: Area2D) -> void:
	if area.is_in_group("Enemies"):
		area.die()
