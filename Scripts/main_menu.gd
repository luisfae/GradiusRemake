extends CanvasLayer

@onready var menu_tilemap: TileMapLayer = $Foreground
@onready var ship: TileMapPattern = menu_tilemap.tile_set.get_pattern(32)
@onready var blackout_one := $OnePlayerBlackOut
@onready var blackout_two := $TwoPlayerBlackOut

#Constantes da HUD
const ONE_PLAYER = Vector2i(9, 16)
const TWO_PLAYER = Vector2i(9, 18)

var singlePlayer: bool
var gameStarting: bool
var igt: float

func _ready() -> void:
	clearCells(ONE_PLAYER, 3, 2)
	singlePlayer = false
	gameStarting = false
	igt = 0.0
	menu_tilemap.position.x = -256
	var tween := create_tween()
	tween.tween_property(menu_tilemap, "position:x", 0, 2.0)
	tween.finished.connect(changeGameMode)

func _physics_process(delta: float) -> void:
	if gameStarting:
		return
	if Input.is_action_just_pressed("select"):
		changeGameMode()
	if Input.is_action_just_pressed("start_game"):
		startGame()

func clearCells(START_CELL: Vector2i, width: int, height: int):
	for x in range(width):
		for y in range(height):
			menu_tilemap.erase_cell(START_CELL + Vector2i(x, y))

func changeGameMode():
	clearCells(ONE_PLAYER, 3, 2)
	clearCells(TWO_PLAYER, 3, 2)
	singlePlayer = !singlePlayer
	if singlePlayer:
		menu_tilemap.set_pattern(ONE_PLAYER, ship)
	else:
		menu_tilemap.set_pattern(TWO_PLAYER, ship)

func startGame():
	gameStarting = true
	AudioManager.play_sfx_gameStart()
	$Timer.start()

func _on_timer_timeout() -> void:
	if singlePlayer:
		blackout_one.visible = !blackout_one.visible
	else:
		blackout_two.visible = !blackout_two.visible
	igt += 0.2
	if igt >= 1.4:
		queue_free()
