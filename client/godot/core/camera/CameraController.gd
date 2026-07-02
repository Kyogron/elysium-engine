extends Node

var camera_rig: Node3D = null
var pivot: Node3D = null
var camera: Camera3D = null

var follow_entity_id := "player_1"
var target := Vector3.ZERO
var distance := 22.0
var min_distance := 12.0
var max_distance := 34.0
var pitch_degrees := -55.0
var yaw_degrees := 45.0
var follow_smoothing := 8.0

func setup(parent: Node3D, initial_target: Vector3 = Vector3.ZERO) -> Camera3D:
	target = initial_target

	camera_rig = Node3D.new()
	camera_rig.name = "CameraRig"
	parent.add_child(camera_rig)

	pivot = Node3D.new()
	pivot.name = "Pivot"
	camera_rig.add_child(pivot)

	camera = Camera3D.new()
	camera.name = "MobaCamera"
	camera.current = true
	camera.fov = 50.0
	pivot.add_child(camera)

	_update_camera_transform()
	return camera

func get_camera() -> Camera3D:
	return camera

func set_follow_entity(entity_id: String) -> void:
	follow_entity_id = entity_id

func set_target(value: Vector3) -> void:
	target = value
	_update_camera_transform()

func zoom(delta: float) -> void:
	distance = clamp(distance + delta, min_distance, max_distance)
	_update_camera_transform()

func _process(delta: float) -> void:
	var follow_node := WorldManager.get_entity(follow_entity_id)
	if follow_node != null:
		target = target.lerp(follow_node.global_position, clamp(delta * follow_smoothing, 0.0, 1.0))

	_update_camera_transform()

func _unhandled_input(event: InputEvent) -> void:
	if event is InputEventMouseButton and event.pressed:
		if event.button_index == MOUSE_BUTTON_WHEEL_UP:
			zoom(-1.5)
		elif event.button_index == MOUSE_BUTTON_WHEEL_DOWN:
			zoom(1.5)

func _update_camera_transform() -> void:
	if camera_rig == null or pivot == null or camera == null:
		return

	camera_rig.global_position = target
	camera_rig.rotation_degrees = Vector3(0.0, yaw_degrees, 0.0)
	pivot.rotation_degrees = Vector3(pitch_degrees, 0.0, 0.0)
	camera.position = Vector3(0.0, 0.0, distance)
