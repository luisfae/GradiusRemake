extends Area2D
class_name Upgrade

var points: int = 500

func _on_body_entered(body: Node2D) -> void:
	if body is Player:
		GlobalVars.getUpgrade()
		AudioManager.play_sfx_upgradeGet()
		GlobalVars.receiveScore(points)
		queue_free()
