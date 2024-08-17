extends Node3D

# Based on Nanotech Gamedev RTS camera (https://youtu.be/t-tkFxhpiCs?si=kr-3Gi1DJYnW4yRj)

@export_range(0, 100, 1) var move_speed := 20.0
@export_range(0, 100, 1) var zoom_min := 0.0
@export_range(0, 100, 1) var zoom_max := 8.0
@export_range(0, 100, 1) var zoom_speed := 40.0
@export_range(0, 2, 0.1) var zoom_damp := 0.9
@export_range(0, 2, 0.1) var rotation_speed := 2

var zoom_direction := 0.0

@onready var socket := $Socket
@onready var camera := $Socket/Camera3D

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	# Move
	var direction := Vector3.ZERO
	direction += Input.get_axis("camera_left", "camera_right") * socket.basis.x
	direction += Input.get_axis("camera_forward", "camera_back") * socket.basis.z
	direction.y = 0
	position += direction.normalized() * delta * move_speed

	# Zoom
	# TODO: On the video they did this on _unhandled_input, why?
	if Input.is_action_just_pressed("camera_zoom_out"):
		zoom_direction = 1
	elif Input.is_action_just_pressed("camera_zoom_in"):
		zoom_direction = -1
	camera.position.z = clamp(
		camera.position.z + zoom_direction * delta * zoom_speed,
		zoom_min,
		zoom_max,
	)
	zoom_direction *= zoom_damp

	# Rotation
	var rotation_direction := Input.get_axis("camera_rotate_left", "camera_rotate_right")
	socket.rotate_y(rotation_direction * delta * rotation_speed)
