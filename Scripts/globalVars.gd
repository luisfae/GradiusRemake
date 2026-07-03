extends Node

@onready var upgrade: int
signal UpgradeSpeed
signal UpgradeMissile
signal UpgradeDouble
signal UpgradeLaser
signal UpgradeOption
signal UpgradeShield
signal UpgradeGet(upgrade: int)
signal ShieldDeactivated(upgrade: int)
@onready var UpgradeObject = preload("res://Scenes/upgrade.tscn")

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

func resetUpgrade() -> void:
	upgrade = 0
	UpgradeGet.emit(upgrade)

func deactivateShield() -> void:
	ShieldDeactivated.emit(upgrade)
	
func createUpgrade(position: Vector2) -> void:
	var u = UpgradeObject.instantiate() as Upgrade
	var main_scene = get_tree().current_scene # não sabia exatamente como criar no Main pq esse script n ta em nada, nao podia chamar owner.add_child
	u.position = position
	main_scene.add_child(u)
