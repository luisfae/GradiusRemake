extends Node2D

@onready var rock = preload("res://Scenes/projectile_rock_volcano.tscn")
var spawning: bool
var seconds_elapsed: float

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	spawning = true
	seconds_elapsed = 0.0

# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta: float) -> void:
	#pass

func _physics_process(_delta: float) -> void:
	if Input.is_action_just_pressed("fire"):
		print("FOI")
		queue_free()
	
func spawnRock():
	var b = rock.instantiate() as Projectile_Rock_Volcano
	b.position = global_position
	owner.add_child(b)

func _on_timer_timeout() -> void:
	if spawning:
		spawnRock()
		seconds_elapsed += 0.2
	if seconds_elapsed > 17:
		GlobalVars.VolcanoEndSpawning()
		queue_free()
		spawning = false
