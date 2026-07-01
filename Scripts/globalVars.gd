extends Node

@onready var upgrade: int
@onready var health: int
signal UpgradeSpeed
signal UpgradeMissile
signal UpgradeDouble
signal UpgradeLaser
signal UpgradeOption
signal UpgradeShield
signal UpgradeGet(upgrade: int)
signal KillPlayer
signal WeakShield

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	health = 1
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

func hitPlayer():
	health -= 1
	if health <= 3:
		WeakShield.emit()
	if health <= 0:
		KillPlayer.emit()
