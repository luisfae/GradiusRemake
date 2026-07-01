extends Node2D

var path_history: Array[Vector2] = []
var speed: float = 50.0 
@export var follow_distance: float = 25.0

var target_node: Node2D
var player_ship: Player

func _ready() -> void:
	var camera_node = get_parent()
	if camera_node and camera_node.has_node("AnimatedShip"):
		player_ship = camera_node.get_node("AnimatedShip") as Player

func _process(delta: float) -> void:
	if not target_node or not is_instance_valid(target_node):
		return

	if player_ship and is_instance_valid(player_ship):
		speed = player_ship.speed
	else:
		speed = 250.0

	var target_global_center: Vector2 = target_node.global_position
	if target_node.has_node("AnimatedSprite2D"):
		var anim_sprite = target_node.get_node("AnimatedSprite2D") as AnimatedSprite2D
		if anim_sprite:
			#target_global_center += anim_sprite.offset
			target_global_center += anim_sprite.position
			if anim_sprite.animation.get_basename() == "Standard" or anim_sprite.animation.get_basename() == "Up" or anim_sprite.animation.get_basename() == "Down":
				target_global_center.x -= 3 #offset hard coded pra ficar identico ao jogo

	var target_local_pos: Vector2 = get_parent().to_local(target_global_center)
	if path_history.is_empty() or path_history.back().distance_to(target_local_pos) > 1.0:
		path_history.append(target_local_pos)

	var total_path_length: float = 0.0
	var current_pos = position
	for point in path_history:
		total_path_length += current_pos.distance_to(point)
		current_pos = point

	if total_path_length > follow_distance and not path_history.is_empty():
		target_local_pos = path_history[0]
		position = position.move_toward(target_local_pos, speed * delta)
		if position.distance_to(target_local_pos) < 3.0:
			path_history.remove_at(0)
