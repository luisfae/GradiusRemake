extends Area2D
class_name Upgrade

var points: int = 500
var killer: bool = false

@onready var sprite = $AnimatedSprite2D

func _ready() -> void:
	GlobalVars.KillAllUpgrades.connect(die)

func _on_body_entered(body: Node2D) -> void:
	if body is Player:
		if killer:
			GlobalVars.getUpgradeKiller()
			AudioManager.play_sfx_upgradeGet() # tocar audio de limpar tela
			queue_free()
		else:
			GlobalVars.getUpgrade()
			AudioManager.play_sfx_upgradeGet()
			GlobalVars.receiveScore(points)
			queue_free()

func setKiller() -> void:
	killer = true
	sprite.play("Killer")

func die() -> void:
	queue_free()

func _on_visible_on_screen_notifier_2d_screen_exited() -> void:
	queue_free()
