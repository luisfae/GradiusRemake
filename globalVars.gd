extends Node

@onready var upgrade: int
signal UpgradeSpeed
signal UpgradeMissile
signal UpgradeDouble
signal UpgradeLaser
signal UpgradeOption
signal UpgradeShield
signal UpgradeGet(upgrade: int)

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass

func getUpgrade() -> void:
	upgrade += 1
	if upgrade > 6:
		upgrade = 1
	UpgradeGet.emit(upgrade)
	print("Upgrade: ", upgrade)

func applyUpgrade() -> void:
	match upgrade:
		0:
			print("Upgrade está zerado. Nada acontece feijoada")
			return
		1:
			print("Aplicando upgrade SpeedUp")
			UpgradeSpeed.emit()
			pass
		2:
			print("Aplicando upgrade Missile")
			UpgradeMissile.emit()
			pass
		3:
			print("Aplicando upgrade Double")
			UpgradeDouble.emit()
			pass
		4:
			print("Aplicando upgrade Laser")
			UpgradeLaser.emit()
			pass
		5:
			print("Aplicando upgrade Option")
			UpgradeOption.emit()
			pass
		6:
			print("Aplicando upgrade ?")
			UpgradeShield.emit()
			pass
	upgrade = 0
	UpgradeGet.emit(upgrade)
