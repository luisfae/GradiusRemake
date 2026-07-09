extends CanvasLayer

@onready var hud_tilemap: TileMapLayer = $Foreground

#Constantes da HUD
const SPEEDUP_TILE = Vector2i(4, 26)
const MISSILE_TILE = Vector2i(8, 26)
const DOUBLE_TILE = Vector2i(12, 26)
const LASER_TILE = Vector2i(16, 26)
const OPTION_TILE = Vector2i(20, 26)
const SHIELD_TILE = Vector2i(24, 26)

#constantes pra não se perder em oq é oq nos vetores
const SPEED = 0
const MISSILE = 1
const DOUBLE = 2
const LASER = 3
const OPTION = 4
const SHIELD = 5
const BLANK = 25

#constantes das posições de números na tela
const score_0 = Vector2i(11,27)
const score_1 = Vector2i(12,27)
const score_2 = Vector2i(13,27)
const score_3 = Vector2i(14,27)
const score_4 = Vector2i(15,27)
const score_5 = Vector2i(16,27)
const score_6 = Vector2i(17,27)

@onready var score_hud_positions : Array[Vector2i] = [score_6, score_5, score_4, score_3, score_2, score_1, score_0]

#constantes dos números no padrão de spritesheet
@onready var number_1: TileMapPattern = hud_tilemap.tile_set.get_pattern(14)
@onready var number_2: TileMapPattern = hud_tilemap.tile_set.get_pattern(15)
@onready var number_3: TileMapPattern = hud_tilemap.tile_set.get_pattern(16)
@onready var number_4: TileMapPattern = hud_tilemap.tile_set.get_pattern(17)
@onready var number_5: TileMapPattern = hud_tilemap.tile_set.get_pattern(18)
@onready var number_6: TileMapPattern = hud_tilemap.tile_set.get_pattern(19)
@onready var number_7: TileMapPattern = hud_tilemap.tile_set.get_pattern(20)
@onready var number_8: TileMapPattern = hud_tilemap.tile_set.get_pattern(21)
@onready var number_9: TileMapPattern = hud_tilemap.tile_set.get_pattern(22)
@onready var number_0: TileMapPattern = hud_tilemap.tile_set.get_pattern(23)

#vetor de padrões pra poder modificar eles apenas com logica e sem ifs
var patternNow: Array = [0, 1, 2, 3, 4, 5]
const patternInitial: Array = [0, 1, 2, 3, 4, 5]

var optionsCalled: int = 0

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	GlobalVars.UpgradeGet.connect(UpgradeGet)
	GlobalVars.UpgradeSpeed.connect(UpgradeSpeed)
	GlobalVars.UpgradeMissile.connect(UpgradeMissile)
	GlobalVars.UpgradeDouble.connect(UpgradeDouble)
	GlobalVars.UpgradeLaser.connect(UpgradeLaser)
	GlobalVars.UpgradeOption.connect(UpgradeOption)
	GlobalVars.UpgradeShield.connect(UpgradeShield)
	GlobalVars.ShieldDeactivated.connect(ShieldDeactivated)
	GlobalVars.KonamiCode.connect(KonamiCode)
	GlobalVars.UpdateScore.connect(UpdateScore)
	UpdateScore(0)

func resetUpgrades() -> void:
	hud_tilemap.set_pattern(SPEEDUP_TILE, hud_tilemap.tile_set.get_pattern(patternNow[SPEED]))
	hud_tilemap.set_pattern(MISSILE_TILE, hud_tilemap.tile_set.get_pattern(patternNow[MISSILE]))
	hud_tilemap.set_pattern(DOUBLE_TILE, hud_tilemap.tile_set.get_pattern(patternNow[DOUBLE]))
	hud_tilemap.set_pattern(LASER_TILE, hud_tilemap.tile_set.get_pattern(patternNow[LASER]))
	hud_tilemap.set_pattern(OPTION_TILE, hud_tilemap.tile_set.get_pattern(patternNow[OPTION]))
	hud_tilemap.set_pattern(SHIELD_TILE, hud_tilemap.tile_set.get_pattern(patternNow[SHIELD]))
	
	#função pra zerar tudo, pra quando o jogador morrer ou voltar ao menu, talvez modificar ou criar outra, se ele morre com upgrades ele ja começa no SPEED
func resetUpgrades_to_initial() -> void:
	hud_tilemap.set_pattern(SPEEDUP_TILE, hud_tilemap.tile_set.get_pattern(patternInitial[SPEED]))
	hud_tilemap.set_pattern(MISSILE_TILE, hud_tilemap.tile_set.get_pattern(patternInitial[MISSILE]))
	hud_tilemap.set_pattern(DOUBLE_TILE, hud_tilemap.tile_set.get_pattern(patternInitial[DOUBLE]))
	hud_tilemap.set_pattern(LASER_TILE, hud_tilemap.tile_set.get_pattern(patternInitial[LASER]))
	hud_tilemap.set_pattern(OPTION_TILE, hud_tilemap.tile_set.get_pattern(patternInitial[OPTION]))
	hud_tilemap.set_pattern(SHIELD_TILE, hud_tilemap.tile_set.get_pattern(patternInitial[SHIELD]))
	optionsCalled = 0
	GlobalVars.resetUpgrade()
	
func UpgradeGet(upgrade: int) -> void:
	resetUpgrades()
	match upgrade:
		0:
			return
		1: # esse +6 é o espaçamento entre cada padrão e seu estado selecionado, tive q adicionar 5 padrões iguais pq o blank space era o 25 e queria q fosse +6 pra todos
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
	GlobalVars.resetUpgrade()
	pass

func UpgradeMissile() -> void:
	if patternNow[MISSILE] != 25:
		patternNow[MISSILE] = BLANK
		GlobalVars.resetUpgrade()
	pass
	
func UpgradeDouble() -> void: #não pode possuir laser e double ao mesmo tempo, quando ativa um, desativa outro
	if patternNow[DOUBLE] != 25:
		patternNow[DOUBLE] = BLANK
		patternNow[LASER] = patternInitial[LASER]
		GlobalVars.resetUpgrade()
	pass
	
func UpgradeLaser() -> void:
	if patternNow[LASER] != 25:
		patternNow[LASER] = BLANK
		patternNow[DOUBLE] = patternInitial[DOUBLE]
		GlobalVars.resetUpgrade()
	pass
	
func UpgradeOption() -> void:
	if patternNow[OPTION] != 25:
		optionsCalled += 1
		if optionsCalled == 2:
			patternNow[OPTION] = BLANK
		GlobalVars.resetUpgrade()
	pass
	
func UpgradeShield() -> void:
	if patternNow[SHIELD] != 25:
		patternNow[SHIELD] = BLANK
		GlobalVars.resetUpgrade()
	pass

func ShieldDeactivated(upgrade: int) -> void:
	patternNow[SHIELD] = patternInitial[SHIELD]
	if(upgrade == 6):
		hud_tilemap.set_pattern(SHIELD_TILE, hud_tilemap.tile_set.get_pattern(patternNow[SHIELD] + 6))
	else:
		hud_tilemap.set_pattern(SHIELD_TILE, hud_tilemap.tile_set.get_pattern(patternNow[SHIELD]))
	pass
	
func KonamiCode() -> void:
	if patternNow[MISSILE] != 25:
		patternNow[MISSILE] = BLANK
	if patternNow[SHIELD] != 25:
		patternNow[SHIELD] = BLANK
	if patternNow[OPTION] != 25:
		patternNow[OPTION] = BLANK
	resetUpgrades()
	
func UpdateScore(score: int):
	var segmentedScore: Array[int]
	var formatedScore = "%07d" % score #maneira q encontrei de colocar zeros após o score
	for c in formatedScore:
		segmentedScore.append(int(c))
	segmentedScore.reverse() # só tem q inverter pra escrever da esquerda pra direita na tela como fazemos
	
	for i in range(7):
		UpdateScoreHUD(i, segmentedScore[i])

func UpdateScoreHUD(index: int, score: int):
	var pattern : TileMapPattern
	match score:
		1:
			pattern = number_1
		2:
			pattern = number_2
		3:
			pattern = number_3
		4:
			pattern = number_4
		5:
			pattern = number_5
		6:
			pattern = number_6
		7:
			pattern = number_7
		8:
			pattern = number_8
		9:
			pattern = number_9
		0:
			pattern = number_0
	hud_tilemap.set_pattern(score_hud_positions[index], pattern)
