extends Area2D
class_name Missile

@export var speed: float = 125.0
@export var speedX: float = 60.0
@onready var sprite = $AnimatedSprite2D
var father: int = 0

signal MyFatherIs(myFather: int)

@onready var ray_down: RayCast2D = $RayCastDown
@onready var ray_forward: RayCast2D = $RayCastForward

func _ready() -> void:
	sprite.play("Down")

func _physics_process(delta: float) -> void:
	if ray_forward.is_colliding():
		die()
		return

	if ray_down.is_colliding():
		if sprite.animation != "Straight":
			sprite.play("Straight")
			
		position.x += speed * delta
		
		var collision_point = ray_down.get_collision_point()
		global_position.y = collision_point.y - 2 # hardcode pra ele ficar acima do chão sempre
		
	else:
		if sprite.animation != "Down":
			sprite.play("Down")
			
		position.x += speedX * delta
		position.y += speed * delta

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
	MyFatherIs.emit(father)
	queue_free()

func _on_area_entered(area: Area2D) -> void:
	if area.is_in_group("Missile Detector"):
		die()
