extends Node3D

var status_label: Label
var world_root: Node3D
var camera: Camera3D

func _ready() -> void:
	_build_world()
	_build_ui()
	WorldManager.set_world_root(world_root)
	camera = CameraController.setup(self)
	CameraController.set_follow_entity("player_1")
	InputController.setup(camera)
	InputController.move_requested.connect(_on_move_requested)
	NetworkManager.connected_to_server.connect(_on_connected)
	NetworkManager.disconnected_from_server.connect(_on_disconnected)
	NetworkManager.message_received.connect(_on_message_received)
	NetworkManager.connect_to_server("ws://localhost:8080")

func _build_world() -> void:
	var light := DirectionalLight3D.new()
	light.name = "Sun"
	light.rotation_degrees = Vector3(-45.0, 35.0, 0.0)
	add_child(light)

	world_root = Node3D.new()
	world_root.name = "WorldRoot"
	add_child(world_root)

	var ground_mesh := PlaneMesh.new()
	ground_mesh.size = Vector2(48.0, 32.0)
	var ground := MeshInstance3D.new()
	ground.name = "Ground"
	ground.mesh = ground_mesh
	var ground_mat := StandardMaterial3D.new()
	ground_mat.albedo_color = Color(0.13, 0.38, 0.16)
	ground.material_override = ground_mat
	add_child(ground)

	var ground_body := StaticBody3D.new()
	ground_body.name = "GroundCollider"
	var ground_shape := CollisionShape3D.new()
	var box := BoxShape3D.new()
	box.size = Vector3(48.0, 0.1, 32.0)
	ground_shape.shape = box
	ground_body.add_child(ground_shape)
	add_child(ground_body)

	var lane_mesh := BoxMesh.new()
	lane_mesh.size = Vector3(36.0, 0.05, 4.0)
	var lane := MeshInstance3D.new()
	lane.name = "Lane"
	lane.mesh = lane_mesh
	lane.position = Vector3(0.0, 0.03, 0.0)
	var lane_mat := StandardMaterial3D.new()
	lane_mat.albedo_color = Color(0.45, 0.42, 0.34)
	lane.material_override = lane_mat
	add_child(lane)

func _build_ui() -> void:
	var canvas := CanvasLayer.new()
	canvas.name = "UI"
	add_child(canvas)

	var panel := Panel.new()
	panel.position = Vector2(16.0, 16.0)
	panel.size = Vector2(420.0, 110.0)
	canvas.add_child(panel)

	status_label = Label.new()
	status_label.position = Vector2(16.0, 16.0)
	status_label.size = Vector2(390.0, 80.0)
	status_label.text = "Elysium Engine\nConnecting to local server...\nRight-click the ground to move."
	panel.add_child(status_label)

func _on_connected() -> void:
	status_label.text = "Elysium Engine\nConnected to server.\nRight-click the ground to move."

func _on_disconnected() -> void:
	status_label.text = "Elysium Engine\nDisconnected from server."

func _on_message_received(message: Dictionary) -> void:
	if message.get("type") != "server.hello":
		return

	var payload = message.get("payload", {})
	status_label.text = "Server: " + str(payload.get("name", "")) + " " + str(payload.get("version", "")) + "\nRight-click the ground to move."

func _on_move_requested(target: Vector3) -> void:
	NetworkManager.send_message("player.move", {
		"target": {
			"x": target.x,
			"y": target.y,
			"z": target.z
		}
	})
