extends Camera2D

@export var speed: float = 20.0
@export var stopped: bool = false


func _ready() -> void:
	GlobalVars.StopCamera.connect(StopCamera)
	GlobalVars.StartCamera.connect(StartCamera)

func _process(delta: float) -> void:
	if !stopped:
		position.x += speed * delta

func StopCamera() -> void:
	stopped = true

func StartCamera() -> void:
	stopped = false
