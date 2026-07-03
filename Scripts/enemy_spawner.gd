extends Area2D

enum types {RUGAL, VAIVEM, FAN, DAI01, DAI01RED}
@export var enemy_type: types
@export var active: bool = true
@onready var rugal = preload("res://Scenes/enemy_rugal.tscn")
@onready var dai01 = preload("res://Scenes/enemy_dai_01.tscn")
@onready var dai01red = preload("res://Scenes/enemy_dai_01_red.tscn")

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass

func setActive() -> void:
	active = true

func _on_area_entered(area: Area2D) -> void:
	if active:
		if area.is_in_group("Front Detector"):
			active = false
			match enemy_type:
				types.RUGAL: # Rugal
					var e = rugal.instantiate() as Rugal
					e.position = global_position
					#owner.add_child(e)
					get_tree().current_scene.call_deferred("add_child", e)
				types.DAI01: # Dai 01 turret
					var e = dai01.instantiate() as Dai
					e.position = global_position
					#owner.add_child(e)
					get_tree().current_scene.call_deferred("add_child", e)
				types.DAI01RED: # Dai 01 turret
					var e = dai01red.instantiate() as Dai
					e.position = global_position
					#owner.add_child(e)
					get_tree().current_scene.call_deferred("add_child", e)
