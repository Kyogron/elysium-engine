extends Node

var camera: Camera3D = null
var target := Vector3.ZERO
var distance := 22.0
var min_distance := 12.0
var max_distance := 32.0

func setup(parent: Node3D, follow_target: Vector3 = Vector3.ZERO) -> Camera3D:
	target = follow_target
	camera = Camera3D.new()
	camera.name = "MobaCamera"
	camera.current = true
	camera.fov = 50.0
	parent.add_child(camera)
	_update_camera_transform()
	return camera

func set_target(value: Vector3) -> void:
	target = value
	_update_camera_transform()

func zoom(delta: float) -> void:
	distance = clamp(distance + delta, min_distance, max_distance)
	_update_camera_transform()

func _process(_delta: float) -> void:
	if camera != null:
		_update_camera_transform()

func _unhandled_input(event: InputEvent) -> void:
	if event is InputEventMouseButton and event.pressed:
		if event.button_index == MOUSE_BUTTON_WHEEL_UP:
			zoom(-1.5)
		elif event.button_index == MOUSE_BUTTON_WHEEL_DOWN:
			zoom(1.5)

func _update_camera_transform() -> void:
	if camera == null:
		return

	var offset := Vector3(distance * 0.7, distance * 0.85, distance * 0.7)
	camera.global_position = target + offset
	camera.rotation_degrees = Vector3(-55.0, 45.0, 0.0)
