extends Area2D
class_name Bullet

@export var speed: float = 700.0
@onready var sprite = $AnimatedSprite2D
@export var type: String = "Straight"

func _ready() -> void:
	sprite.play(type)
	#var tween = get_tree().create_tween()
	#tween.set_trans(Tween.TRANS_BOUNCE)
	#tween.set_ease(Tween.EASE_OUT)
	#tween.tween_property(self, "position", Vector2(2.0, 2.0), 2.0)
	#tween.tween_property(self, "position", Vector2.ONE, 1.0)

func _physics_process(delta: float) -> void:
	# Move forward along the local X-axis
	if type == "Straight":
		position += transform.x * speed * delta
	else:
		position += transform.x * speed * delta
		position -= transform.y * speed * delta

func set_up() -> void:
	type = "Up"

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
		#queue_free()

func _on_area_entered(area: Area2D) -> void:
	if area.is_in_group("Enemies"):
		area.die()
		queue_free()
