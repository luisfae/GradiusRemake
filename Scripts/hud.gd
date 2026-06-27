extends CanvasLayer

@onready var hud_tilemap: TileMapLayer = $Foreground

#Constantes da HUD
const SPEEDUP_TILE = Vector2i(4, 26)
const MISSILE_TILE = Vector2i(8, 26)
const DOUBLE_TILE = Vector2i(12, 26)
const LASER_TILE = Vector2i(16, 26)
const OPTION_TILE = Vector2i(20, 26)
const SHIELD_TILE = Vector2i(24, 26)

#Constantes pra não se perder em oq é oq nos vetores
const SPEED = 0
const MISSILE = 1
const DOUBLE = 2
const LASER = 3
const OPTION = 4
const SHIELD = 5
const BLANK = 25

#Vetor de padrões pra poder modificar eles apenas com logica e sem ifs
var patternNow: Array = [0, 1, 2, 3, 4, 5]
const patternInitial: Array = [0, 1, 2, 3, 4, 5]

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	GlobalVars.UpgradeGet.connect(UpgradeGet)
	GlobalVars.UpgradeSpeed.connect(UpgradeSpeed)
	GlobalVars.UpgradeMissile.connect(UpgradeMissile)
	GlobalVars.UpgradeDouble.connect(UpgradeDouble)
	GlobalVars.UpgradeLaser.connect(UpgradeLaser)
	GlobalVars.UpgradeOption.connect(UpgradeOption)
	GlobalVars.UpgradeShield.connect(UpgradeShield)

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
	
func resetUpgrades() -> void:
	hud_tilemap.set_pattern(SPEEDUP_TILE, hud_tilemap.tile_set.get_pattern(patternNow[SPEED]))
	hud_tilemap.set_pattern(MISSILE_TILE, hud_tilemap.tile_set.get_pattern(patternNow[MISSILE]))
	hud_tilemap.set_pattern(DOUBLE_TILE, hud_tilemap.tile_set.get_pattern(patternNow[DOUBLE]))
	hud_tilemap.set_pattern(LASER_TILE, hud_tilemap.tile_set.get_pattern(patternNow[LASER]))
	hud_tilemap.set_pattern(OPTION_TILE, hud_tilemap.tile_set.get_pattern(patternNow[OPTION]))
	hud_tilemap.set_pattern(SHIELD_TILE, hud_tilemap.tile_set.get_pattern(patternNow[SHIELD]))
	
	#Função pra zerar tudo, pra quando o jogador morrer ou voltar ao menu, talvez modificar ou criar outra, se ele morre com upgrades ele ja começa no SPEED
func resetUpgrades_to_initial() -> void:
	hud_tilemap.set_pattern(SPEEDUP_TILE, hud_tilemap.tile_set.get_pattern(patternInitial[SPEED]))
	hud_tilemap.set_pattern(MISSILE_TILE, hud_tilemap.tile_set.get_pattern(patternInitial[MISSILE]))
	hud_tilemap.set_pattern(DOUBLE_TILE, hud_tilemap.tile_set.get_pattern(patternInitial[DOUBLE]))
	hud_tilemap.set_pattern(LASER_TILE, hud_tilemap.tile_set.get_pattern(patternInitial[LASER]))
	hud_tilemap.set_pattern(OPTION_TILE, hud_tilemap.tile_set.get_pattern(patternInitial[OPTION]))
	hud_tilemap.set_pattern(SHIELD_TILE, hud_tilemap.tile_set.get_pattern(patternInitial[SHIELD]))
	
func UpgradeGet(upgrade: int) -> void:
	resetUpgrades()
	match upgrade:
		0:
			return
		1: # +6 é o espaçamento entre cada padrão e seu estado selecionado, tive q adicionar 5 padrões iguais pq o blank space era o 25 e queria q fosse +6 pra todos
			hud_tilemap.set_pattern(SPEEDUP_TILE, hud_tilemap.tile_set.get_pattern(patternNow[SPEED] + 6)) 
			pass
		2:
			hud_tilemap.set_pattern(MISSILE_TILE, hud_tilemap.tile_set.get_pattern(patternNow[MISSILE] + 6))
			pass
		3:
			hud_tilemap.set_pattern(DOUBLE_TILE, hud_tilemap.tile_set.get_pattern(patternNow[DOUBLE] + 6))
			pass
		4:
			hud_tilemap.set_pattern(LASER_TILE, hud_tilemap.tile_set.get_pattern(patternNow[LASER] + 6))
			pass
		5:
			hud_tilemap.set_pattern(OPTION_TILE, hud_tilemap.tile_set.get_pattern(patternNow[OPTION] + 6))
			pass
		6:
			hud_tilemap.set_pattern(SHIELD_TILE, hud_tilemap.tile_set.get_pattern(patternNow[SHIELD] + 6))
			pass

func UpgradeSpeed() -> void:
	pass

func UpgradeMissile() -> void:
	patternNow[MISSILE] = BLANK
	pass
	
func UpgradeDouble() -> void: #não pode possuir laser e double ao mesmo tempo, quando ativa um, desativa outro
	patternNow[DOUBLE] = BLANK
	patternNow[LASER] = patternInitial[LASER]
	pass
	
func UpgradeLaser() -> void:
	patternNow[LASER] = BLANK
	patternNow[DOUBLE] = patternInitial[DOUBLE]
	pass
	
func UpgradeOption() -> void:
	patternNow[OPTION] = BLANK
	pass
	
func UpgradeShield() -> void:
	pass
