extends Node2D

@onready var shield1 = $Shield_1
@onready var shield2 = $Shield_2
@onready var shield3 = $Shield_3
@onready var shield4 = $Shield_4

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass

func playerCollides(body: Node2D) -> void:
	pass

func _on_ship_top_body_entered(body: Node2D) -> void:
	if body.is_in_group("Player"):
		GlobalVars.hitPlayer()


func _on_ship_bottom_body_entered(body: Node2D) -> void:
	if body.is_in_group("Player"):
		GlobalVars.hitPlayer()


func _on_shield_1_body_entered(body: Node2D) -> void:
	if body.is_in_group("Player"):
		GlobalVars.hitPlayer()


func _on_shield_2_body_entered(body: Node2D) -> void:
	if body.is_in_group("Player"):
		GlobalVars.hitPlayer()


func _on_shield_3_body_entered(body: Node2D) -> void:
	if body.is_in_group("Player"):
		GlobalVars.hitPlayer()


func _on_shield_4_body_entered(body: Node2D) -> void:
	if body.is_in_group("Player"):
		GlobalVars.hitPlayer()
