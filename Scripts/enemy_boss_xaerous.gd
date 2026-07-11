extends Node2D

enum State {UP, DOWN}
var current_state: State = State.UP
@export var speed: float = 60.0
var movement_vector: Vector2 = Vector2.ZERO
var camera: Camera2D = null
var points: int = 10000
@onready var screen_height: float = get_viewport().get_visible_rect().size.y
@onready var action_timer: Timer = $Timer
@onready var change_direction: bool = false
@onready var shield1 = $Shield_1
@onready var shield2 = $Shield_2
@onready var shield3 = $Shield_3
@onready var shield4 = $Shield_4
@onready var ray_left: RayCast2D = $RayCastLeft

@onready var boss_shot = preload("res://Scenes/enemy_boss_xaerous_shot.tscn")

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	action_timer.autostart = true
	camera = get_viewport().get_camera_2d()

func _physics_process(delta: float) -> void:
	if !camera:
		return
	ray_left.force_raycast_update()
	if ray_left.is_colliding():
		change_direction = true
	match current_state:
		State.UP:
			movement_vector.x =  0
			movement_vector.y = -speed * 1.5
			# calculo de onde é esse ponto
			
			var camera_top_edge = camera.global_position.y - (screen_height / 2.0)
			var target_turn_y = camera_top_edge + (screen_height * 0.10)
			
			# troca de estado se chegou
			if global_position.y <= target_turn_y:
				movement_vector.y = 0
				change_direction = true
		State.DOWN:
			movement_vector.x =  0
			movement_vector.y = speed * 1.5
			
			var camera_bot_edge = camera.global_position.y + (screen_height / 2.0)
			var target_turn_y = camera_bot_edge - (screen_height * 0.25)
			
			# troca de estado se chegou
			if global_position.y >= target_turn_y:
				#current_state = State.UP
				movement_vector.y = 0
				change_direction = true
			
	global_position += movement_vector * delta
# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass

func fire():
	var b = boss_shot.instantiate() as Boss_Shot
	b.position = global_position
	#b.position.x += 20
	owner.add_child(b)

# COLISÕES DO PLAYER COM AS DIFERENTES PARTES DO BOSS
func _on_ship_top_body_entered(body: Node2D) -> void:
	if body.is_in_group("Player"):
		body.takeHit()


func _on_ship_bottom_body_entered(body: Node2D) -> void:
	if body.is_in_group("Player"):
		body.takeHit()


func _on_shield_1_body_entered(body: Node2D) -> void:
	if body.is_in_group("Player"):
		body.takeHit()


func _on_shield_2_body_entered(body: Node2D) -> void:
	if body.is_in_group("Player"):
		body.takeHit()


func _on_shield_3_body_entered(body: Node2D) -> void:
	if body.is_in_group("Player"):
		body.takeHit()


func _on_shield_4_body_entered(body: Node2D) -> void:
	if body.is_in_group("Player"):
		body.takeHit()



# COLISÕES DOS TIROS DO PLAYER COM AS DIFERENTES PARTES DO BOSS
func _on_ship_top_area_entered(area: Area2D) -> void:
	pass # Replace with function body.


func _on_ship_bottom_area_entered(area: Area2D) -> void:
	pass # Replace with function body.


func _on_shield_1_area_entered(area: Area2D) -> void:
	pass # Replace with function body.


func _on_shield_2_area_entered(area: Area2D) -> void:
	pass # Replace with function body.


func _on_shield_3_area_entered(area: Area2D) -> void:
	pass # Replace with function body.


func _on_shield_4_area_entered(area: Area2D) -> void:
	pass # Replace with function body.


func _on_core_2_area_entered(area: Area2D) -> void:
	pass # Replace with function body.

func _on_timer_timeout() -> void:
	fire()
	if change_direction:
		if current_state == State.UP:
			current_state = State.DOWN
		else:
			current_state = State.UP
		change_direction = false
