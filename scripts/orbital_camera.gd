extends Node3D

@export var target: Node3D  # The node the camera orbits around
@export var distance: float = 5.0  # Distance from the target
@export var orbit_speed: float = 0.5  # Speed of automatic orbit
@export var y_offset: float = 1.0  # Vertical offset for the camera
@export var min_distance: float = 2.0  # Minimum zoom distance
@export var max_distance: float = 10.0  # Maximum zoom distance

var yaw: float = 0.0  # Horizontal rotation
var pitch: float = 0.0  # Vertical rotation

func _ready() -> void:
	if not target:
		push_error("OrbitCamera: No target assigned!")
		return
	update_camera_position()

func _process(delta: float) -> void:
	yaw += orbit_speed * delta  # Automatically rotate around the target
	update_camera_position()

func update_camera_position() -> void:
	var offset = Vector3.FORWARD * distance
	offset = offset.rotated(Vector3.UP, yaw)
	offset = offset.rotated(Vector3.RIGHT, pitch)
	
	var target_position = target.global_transform.origin + Vector3(0, y_offset, 0)
	global_transform.origin = target_position + offset
	look_at(target_position)
