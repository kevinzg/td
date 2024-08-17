extends RigidBody3D


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	var input := Vector3.ZERO
	input.x = Input.get_axis("player_left", "player_right")
	input.z = Input.get_axis("player_back", "player_forward")
	apply_central_force(input * 1200 * delta)
