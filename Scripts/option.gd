extends Node2D

var path_history: Array[Vector2] = []
var speed: float = 50.0 

@export var frame_delay: int = 15 

var target_node: Node2D
@onready var player: CharacterBody2D = get_tree().get_first_node_in_group("Player") as CharacterBody2D

func _ready() -> void:
	pass

func _physics_process(delta: float) -> void:
	if not target_node or not is_instance_valid(target_node):
		return

	if player:
		speed = player.speed
	else:
		speed = 250.0

	var target_global_center: Vector2 = target_node.global_position
	if target_node.has_node("AnimatedSprite2D"):
		var anim_sprite = target_node.get_node("AnimatedSprite2D") as AnimatedSprite2D
		if anim_sprite:
			target_global_center += anim_sprite.position
			if anim_sprite.animation.get_basename() == "Standard" or anim_sprite.animation.get_basename() == "Up" or anim_sprite.animation.get_basename() == "Down":
				target_global_center.x -= 3 
	var target_local_pos: Vector2 = get_parent().to_local(target_global_center)
	var is_pressing_input = Input.get_axis("left", "right") != 0 or Input.get_axis("up", "down") != 0
	var target_moved = path_history.is_empty() or path_history.back().distance_to(target_local_pos) > 0.1
	if target_moved or is_pressing_input:
		path_history.append(target_local_pos)
	if path_history.size() > frame_delay:
		var oldest_target = path_history.pop_front()
		position = position.move_toward(oldest_target, speed * delta)
