extends Camera2D

@export var speed: float = 20.0


func _ready() -> void:
	pass


func _process(delta: float) -> void:
	position.x += speed * delta
	pass
