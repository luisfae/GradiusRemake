extends Area2D

enum types {POINTS, LIFE}
@export var type: types
@onready var points: int = 5000
@onready var sprite = $AnimatedSprite2D
var active: bool = true

func _on_body_entered(body: Node2D) -> void:
	if body.is_in_group("Player") and active:
		active = false
		if type == types.POINTS:
			AudioManager.play_sfx_upgradeGet()
			GlobalVars.receiveScore(points)
			sprite.play("Points")
		else:
			AudioManager.play_sfx_upgradeGet()
			sprite.play("Life")


func _on_visible_on_screen_notifier_2d_screen_exited() -> void:
	queue_free()
