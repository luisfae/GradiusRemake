extends Area2D

enum types {RUGAL, VAIVEM, FAN}
@export var enemy_type: types
@export var active: bool = true
@onready var rugal = preload("res://Scenes/enemy_rugal.tscn")

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
					owner.call_deferred("add_child", e)
					
