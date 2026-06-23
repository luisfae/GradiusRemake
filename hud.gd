extends CanvasLayer

@onready var hud_tilemap: TileMapLayer = $Foreground

#Constantes da HUD
const SPEEDUP_TILE = Vector2i(4, 26)
const MISSILE_TILE = Vector2i(8, 26)
const DOUBLE_TILE = Vector2i(12, 26)
const LASER_TILE = Vector2i(16, 26)
const OPTION_TILE = Vector2i(20, 26)
const SHIELD_TILE = Vector2i(24, 26)

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	GlobalVars.UpgradeGet.connect(UpgradeGet)

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
	
func resetUpgrades() -> void:
	hud_tilemap.set_pattern(SPEEDUP_TILE, hud_tilemap.tile_set.get_pattern(0))
	hud_tilemap.set_pattern(MISSILE_TILE, hud_tilemap.tile_set.get_pattern(1))
	hud_tilemap.set_pattern(DOUBLE_TILE, hud_tilemap.tile_set.get_pattern(2))
	hud_tilemap.set_pattern(LASER_TILE, hud_tilemap.tile_set.get_pattern(3))
	hud_tilemap.set_pattern(OPTION_TILE, hud_tilemap.tile_set.get_pattern(4))
	hud_tilemap.set_pattern(SHIELD_TILE, hud_tilemap.tile_set.get_pattern(5))
	
func UpgradeGet(upgrade: int) -> void:
	resetUpgrades()
	match upgrade:
		0:
			return
		1:
			hud_tilemap.set_pattern(SPEEDUP_TILE, hud_tilemap.tile_set.get_pattern(6))
			pass
		2:
			hud_tilemap.set_pattern(MISSILE_TILE, hud_tilemap.tile_set.get_pattern(7))
			pass
		3:
			hud_tilemap.set_pattern(DOUBLE_TILE, hud_tilemap.tile_set.get_pattern(8))
			pass
		4:
			hud_tilemap.set_pattern(LASER_TILE, hud_tilemap.tile_set.get_pattern(9))
			pass
		5:
			hud_tilemap.set_pattern(OPTION_TILE, hud_tilemap.tile_set.get_pattern(10))
			pass
		6:
			hud_tilemap.set_pattern(SHIELD_TILE, hud_tilemap.tile_set.get_pattern(11))
			pass
