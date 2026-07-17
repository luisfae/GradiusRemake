extends Node2D
class_name Volcano

@onready var main_scene = get_tree().current_scene
@onready var rock = preload("res://Scenes/projectile_rock_volcano.tscn")
var spawning: bool
var seconds_elapsed: float

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	spawning = true
	seconds_elapsed = 0.0

	
func spawnRock():
	var b = rock.instantiate() as Projectile_Rock_Volcano
	b.position = global_position
	main_scene.add_child(b)

func _on_timer_timeout() -> void:
	if spawning:
		spawnRock()
		seconds_elapsed += 0.2
	if seconds_elapsed > 17:
		GlobalVars.VolcanoEndSpawning()
		queue_free()
		spawning = false
