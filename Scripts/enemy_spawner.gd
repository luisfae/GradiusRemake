extends Area2D

enum types {RUGAL, GARRUN, GARRUNRED, DAI01, DAI01RED, FAN, RASHE, JUMPER, JUMPERRED, DAKKER, DAKKERRED, DAGOOM, BOSS}
enum spawnReleasePos {FRONT, BACK}
@export var enemy_type: types
@export var spawn_pos: spawnReleasePos
@export var active: bool = true
@onready var enemy

func _ready() -> void:
	match enemy_type:
		types.RUGAL:
			enemy = preload("res://Scenes/enemy_rugal.tscn")
		types.DAI01:
			enemy = preload("res://Scenes/enemy_dai_01.tscn")
		types.DAI01RED:
			enemy = preload("res://Scenes/enemy_dai_01_red.tscn")
		types.GARRUN:
			enemy = preload("res://Scenes/enemy_garrun.tscn")
		types.GARRUNRED:
			enemy = preload("res://Scenes/enemy_garrun_red.tscn")
		types.FAN:
			enemy = preload("res://Scenes/enemy_fan.tscn")
		types.RASHE:
			enemy = preload("res://Scenes/enemy_rashe.tscn")
		types.JUMPER:
			enemy = preload("res://Scenes/enemy_jumper.tscn")
		types.JUMPERRED:
			enemy = preload("res://Scenes/enemy_jumper_red.tscn")
		types.DAKKER:
			enemy = preload("res://Scenes/enemy_dakker.tscn")
		types.DAKKERRED:
			enemy = preload("res://Scenes/enemy_dakker_red.tscn")
		types.DAGOOM:
			enemy = preload("res://Scenes/enemy_dagoom.tscn")
		types.BOSS:
			enemy = preload("res://Scenes/enemy_boss_xaerous.tscn")

func setActive() -> void:
	active = true

func setInactive() -> void:
	active = false

func receiveActive(active_ : bool) -> void:
	active = active_

func _on_area_entered(area: Area2D) -> void:
	if active: # caso o tipo do spawn seja front E colida com o front detector OU se for tipo back E colida com back detector, spawna
		if (area.is_in_group("Front Detector") and spawn_pos == spawnReleasePos.FRONT) or (area.is_in_group("Back Detector") and spawn_pos == spawnReleasePos.BACK):
			active = false
			var spawn_target = get_parent()
			if !spawn_target.name.contains("Group"):
				spawn_target = get_tree().current_scene
			match enemy_type:
				types.RUGAL: # Rugal
					var e = enemy.instantiate() as Rugal
					e.position = global_position
					spawn_target.call_deferred("add_child", e)
					
				types.DAI01: # Dai 01 turret paradinha
					var e = enemy.instantiate() as Dai
					e.position = global_position
					spawn_target.call_deferred("add_child", e)
					
				types.DAI01RED: # Dai 01 turret vermeia paradinha q dropa upgrade
					var e = enemy.instantiate() as Dai
					e.position = global_position
					e.setDropUpgrade()
					spawn_target.call_deferred("add_child", e)
					
				types.GARRUN: # Garrun, famoso vai e vem
					var e = enemy.instantiate() as Garrun
					e.position = global_position
					spawn_target.call_deferred("add_child", e)
					
				types.GARRUNRED: # Garrun vermei q dropa update
					var e = enemy.instantiate() as Garrun
					e.position = global_position
					e.setDropUpgrade()
					spawn_target.call_deferred("add_child", e)
					
				types.FAN: # Fan, primeiro inimigo q aparece
					var e = enemy.instantiate() as Fan
					e.position = global_position
					spawn_target.call_deferred("add_child", e)
					
				types.RASHE: # Rashe, satelete q a maquina la cospe varios
					var e = enemy.instantiate() as Rashe
					e.position = global_position
					spawn_target.call_deferred("add_child", e)
					
				types.JUMPER: # Jumper, fica saltitando la qnd chega na caverna
					var e = enemy.instantiate() as Jumper
					e.position = global_position
					spawn_target.call_deferred("add_child", e)
					
				types.JUMPERRED: # Jumper red, fica saltitando la qnd chega na caverna e dropa upgrade
					var e = enemy.instantiate() as Jumper
					e.position = global_position
					e.setDropUpgrade()
					spawn_target.call_deferred("add_child", e)
					
				types.DAKKER: # Turret do diabo q fica andando e atirando
					var e = enemy.instantiate() as Dakker
					e.position = global_position
					spawn_target.call_deferred("add_child", e)
					
				types.DAKKERRED: # Turret do diabo q fica andando e atirando mas dropa upgrade pelomenos
					var e = enemy.instantiate() as Dakker
					e.position = global_position
					e.setDropUpgrade()
					spawn_target.call_deferred("add_child", e)
					
				types.DAGOOM: # Turret do diabo q fica andando e atirando mas dropa upgrade pelomenos
					var e = enemy.instantiate() as Dagoom
					e.position = global_position
					spawn_target.call_deferred("add_child", e)
					
				types.BOSS: # Turret do diabo q fica andando e atirando mas dropa upgrade pelomenos
					var e = enemy.instantiate() as Xaerous
					e.position = global_position
					spawn_target.call_deferred("add_child", e)
