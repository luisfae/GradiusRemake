extends Area2D

enum types {CHECKPOINT, VULCANEVENT, BOSSEVENT}
@export var checkpoint_type: types

@onready var active: bool = true

func _on_area_entered(area: Area2D) -> void:
	if !active:
		return
	if area.is_in_group("Checkpoint Detector"):
		match checkpoint_type:
			types.CHECKPOINT:
				active = false
				GlobalVars.checkpointAchieved()
			types.VULCANEVENT:
				#vulcan_event.start()
				active = false
				#GlobalVars.stopCamera()
				GlobalVars.startVolcanoEvent()
			types.BOSSEVENT:
				#boss_event.start()
				active = false
				GlobalVars.startBossEvent()

func setActive() -> void:
	active = true
