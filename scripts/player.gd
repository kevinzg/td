extends CharacterBody3D

@export var dest_marker: Node3D
@onready var navigation_agent_3d: NavigationAgent3D = $NavigationAgent3D

var destination := Vector3.ZERO
var direction := Vector3.ZERO

# Navigation based on Bramwell's tutorial (https://youtu.be/2W4JP48oZ8U?si=sewfGVQvYPRPc_lf)

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass

func _input(event: InputEvent) -> void:
	if event.is_action_pressed("mouse_right_click"):
		var pos := get_viewport().get_mouse_position()
		var camera := get_viewport().get_camera_3d()
		var maybe_ray := raycast_screen_position(camera, pos)
		if maybe_ray.is_empty():
			return
		var ray := maybe_ray[0]
		dest_marker.position.x = ray.x
		dest_marker.position.z = ray.z
		dest_marker.visible = true
		navigation_agent_3d.target_position = ray

func _physics_process(delta: float) -> void:
	var dest := navigation_agent_3d.get_next_path_position()
	var local_dest := dest - global_position
	if local_dest.length() < 0.1:
		dest_marker.visible = false # TODO: should probably emit an event here
		return
	var direction := local_dest.normalized()
	velocity = direction * 5.0
	look_at(global_position + velocity, Vector3.UP)
	move_and_slide()

# TODO: ~~this doesn't work, returns a wrong position~~
#		It does work, but the flag transform needs to be set to top level, why?
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
	if result.position:
		return [result.position]
	return []
