extends Node3D

# Based on Nanotech Gamedev RTS camera (https://youtu.be/t-tkFxhpiCs?si=kr-3Gi1DJYnW4yRj)

@export_range(0, 100, 1) var move_speed := 20.0


@onready var socket := $Socket
@onready var camera := $Socket/Camera3D

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	var direction := Vector3.ZERO
	direction.x = Input.get_axis("camera_left", "camera_right")
	direction.z = Input.get_axis("camera_forward", "camera_back")

	position += direction.normalized() * delta * move_speed
