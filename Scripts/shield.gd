extends Node2D

@onready var sprite = $AnimatedSprite2D
var high: bool = true

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	sprite.visible = false
	pass # Replace with function body.

func setLow() -> void:
	sprite.play("Low")
	high = false

func setHigh() -> void:
	sprite.play("High")
	high = true

func activate() -> void:
	setHigh()
	sprite.visible = true

func deactivate() -> void:
	sprite.visible = false
	GlobalVars.deactivateShield()
