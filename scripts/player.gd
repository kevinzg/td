extends RigidBody3D

@export var destination: Node3D

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	var input := Vector3.ZERO
	input.x = Input.get_axis("player_left", "player_right")
	input.z = Input.get_axis("player_back", "player_forward")
	apply_central_force(input * 1200 * delta)

func _input(event: InputEvent) -> void:
	if event.is_action_pressed("mouse_right_click"):
		var pos := get_viewport().get_mouse_position()
		var camera := get_viewport().get_camera_3d()
		var maybe_ray := raycast_screen_position(camera, pos)
		if maybe_ray.is_empty():
			return
		var ray := maybe_ray[0]
		print(ray)
		destination.position.x = ray.x
		destination.position.z = ray.z
		destination.visible = true

# TODO: this doesn't work, returns a wrong position
func raycast_screen_position(camera: Camera3D, pos: Vector2) -> Array[Vector3]:
	const ray_length := 1000.0
	var ray_from := camera.project_ray_origin(pos)
	var ray_to := ray_from + camera.project_ray_normal(pos) * ray_length
	var space = get_world_3d().direct_space_state
	var ray_query = PhysicsRayQueryParameters3D.new()
	ray_query.from = ray_from
	ray_query.to = ray_to
	ray_query.collide_with_areas = true
	ray_query.collide_with_bodies = true
	var result := space.intersect_ray(ray_query)
	print(result)
	if result.position:
		return [result.position]
	return []
