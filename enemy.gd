extends Area2D

class_name Enemy

@onready var sprite = $AnimatedSprite2D
@onready var alive: bool

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	alive = true
	sprite.play("default")


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass

func die():
	alive = false
	print("morreu inimigo")
	sprite.play("Death")
	sprite.animation_finished.connect(onDeathAnimationFinished, CONNECT_ONE_SHOT)


func onDeathAnimationFinished():
	queue_free()

func _on_body_entered(body: Node2D) -> void:
	if body is Player:
		print("MATA O PLAYER")
		body.die()
	if body is Bullet:
		print ("MATA O INIMIGO")
		die()
		
