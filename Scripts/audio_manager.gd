extends Node

@export var mute: bool = false
@export var bgm : Array[AudioStream] = []

@onready var music : AudioStreamPlayer = $Music
@onready var sfx : AudioStreamPlayer = $SFX1
@export var streamPlayers : Array[AudioStreamPlayer]
@export var currentStream: int = 0


@export var sfx_playerFire : AudioStream
@export var sfx_playerLaser : AudioStream
@export var sfx_playerDeath : AudioStream
@export var sfx_upgradeApply : AudioStream
@export var sfx_upgradeGet : AudioStream
@export var sfx_gamePause : AudioStream
@export var sfx_enemyDeath : AudioStream
@export var sfx_volcanoRockDestroy : AudioStream

func _ready() -> void:
	if !mute:
		play_music()

func play_music():
	if !mute:
		$Music.play()
		
func play_bgm_area_1():
	$Music.stream = bgm[0]
func play_bgm_area_2():
	$Music.stream = bgm[1]
func play_bgm_area_3():
	$Music.stream = bgm[2]
	
func play_sfx_playerFire():
	play_sfx(sfx_playerFire)
	
func play_sfx_playerLaser():
	play_sfx(sfx_playerLaser)

func play_sfx_playerDeath():
	play_sfx(sfx_playerDeath)
	
func play_sfx_upgradeGet():
	play_sfx(sfx_upgradeGet)
	
func play_sfx_upgradeApply():
	play_sfx(sfx_upgradeApply)
	
func play_sfx_gamePause():
	play_sfx(sfx_gamePause)
	
func play_sfx_enemyDeath():
	play_sfx(sfx_enemyDeath)

func play_sfx_volcanoRockDestroy():
	play_sfx(sfx_volcanoRockDestroy)
		
func play_sfx(audio : AudioStream, volume : float = 1.0) -> void:
	streamPlayers[currentStream].stream = audio
	streamPlayers[currentStream].volume_linear = volume
	if (!streamPlayers[currentStream].playing):
		streamPlayers[currentStream].play()
	currentStream += 1
	if (currentStream > streamPlayers.size() - 1):
		currentStream = 0
		
func toggleMute():
	mute = !mute
	if mute:
		$Music.stop()
	else:
		$Music.play()

func toggle_bus(bus_name: String) -> void:
	var idx := AudioServer.get_bus_index(bus_name)
	if idx != -1:
		AudioServer.set_bus_mute(idx, !AudioServer.is_bus_mute(idx))
