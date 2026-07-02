extends Node3D

var player: CharacterBody3D
var target_position := Vector3.ZERO
var status_label: Label
var camera: Camera3D
var ray_origin := Vector3.ZERO
var ray_end := Vector3.ZERO

func _ready():
	_build_world()
	_build_ui()
	NetworkManager.connected_to_server.connect(_on_connected)
	NetworkManager.disconnected_from_server.connect(_on_disconnected)
	NetworkManager.message_received.connect(_on_message)
	NetworkManager.connect_to_server("ws://localhost:8080")

func _physics_process(delta):
	if player == null:
		return
	var dir := target_position - player.global_position
	dir.y = 0
	if dir.length() > 0.1:
		player.velocity = dir.normalized() * 6.0
		player.move_and_slide()
	else:
		player.velocity = Vector3.ZERO

func _unhandled_input(event):
	if event is InputEventMouseButton and event.button_index == MOUSE_BUTTON_LEFT and event.pressed:
		var hit := _raycast_mouse(event.position)
		if hit.has("position"):
			target_position = hit.position
			NetworkManager.send_message("player.move", { "x": target_position.x, "y": target_position.z })

func _build_world():
	var light := DirectionalLight3D.new()
	light.name = "Sun"
	light.rotation_degrees = Vector3(-45, 35, 0)
	add_child(light)

	camera = Camera3D.new()
	camera.name = "MobaCamera"
	camera.position = Vector3(0, 18, 18)
	camera.rotation_degrees = Vector3(-55, 0, 0)
	camera.current = true
	add_child(camera)

	var ground_mesh := PlaneMesh.new()
	ground_mesh.size = Vector2(40, 24)
	var ground := MeshInstance3D.new()
	ground.name = "Ground"
	ground.mesh = ground_mesh
	var ground_mat := StandardMaterial3D.new()
	ground_mat.albedo_color = Color(0.13, 0.38, 0.16)
	ground.material_override = ground_mat
	add_child(ground)

	var lane_mesh := BoxMesh.new()
	lane_mesh.size = Vector3(36, 0.05, 4)
	var lane := MeshInstance3D.new()
	lane.name = "Lane"
	lane.mesh = lane_mesh
	lane.position = Vector3(0, 0.03, 0)
	var lane_mat := StandardMaterial3D.new()
	lane_mat.albedo_color = Color(0.45, 0.42, 0.34)
	lane.material_override = lane_mat
	add_child(lane)

	player = CharacterBody3D.new()
	player.name = "PlayerChampion"
	player.position = Vector3(-6, 0.6, 0)
	add_child(player)

	var capsule := CapsuleMesh.new()
	capsule.radius = 0.45
	capsule.height = 1.6
	var body := MeshInstance3D.new()
	body.name = "Body"
	body.mesh = capsule
	var body_mat := StandardMaterial3D.new()
	body_mat.albedo_color = Color(0.2, 0.55, 1.0)
	body.material_override = body_mat
	player.add_child(body)

	_add_tower(Vector3(-14, 1.2, 0), Color(0.1, 0.45, 1.0), "BlueTower")
	_add_tower(Vector3(14, 1.2, 0), Color(1.0, 0.18, 0.18), "RedTower")

	target_position = player.global_position

func _add_tower(pos: Vector3, color: Color, tower_name: String):
	var mesh := CylinderMesh.new()
	mesh.top_radius = 0.55
	mesh.bottom_radius = 0.75
	mesh.height = 2.4
	var tower := MeshInstance3D.new()
	tower.name = tower_name
	tower.mesh = mesh
	tower.position = pos
	var mat := StandardMaterial3D.new()
	mat.albedo_color = color
	tower.material_override = mat
	add_child(tower)

func _build_ui():
	var canvas := CanvasLayer.new()
	canvas.name = "UI"
	add_child(canvas)

	var panel := Panel.new()
	panel.position = Vector2(16, 16)
	panel.size = Vector2(420, 110)
	canvas.add_child(panel)

	status_label = Label.new()
	status_label.position = Vector2(16, 16)
	status_label.size = Vector2(390, 80)
	status_label.text = "Elysium Engine\nConectando ao servidor...\nClique no chão para mover."
	panel.add_child(status_label)

func _raycast_mouse(mouse_pos: Vector2) -> Dictionary:
	var space_state := get_world_3d().direct_space_state
	ray_origin = camera.project_ray_origin(mouse_pos)
	ray_end = ray_origin + camera.project_ray_normal(mouse_pos) * 1000
	var query := PhysicsRayQueryParameters3D.create(ray_origin, ray_end)
	return space_state.intersect_ray(query)

func _on_connected():
	status_label.text = "Elysium Engine\nConectado ao servidor.\nClique no chão para mover."

func _on_disconnected():
	status_label.text = "Elysium Engine\nDesconectado do servidor."

func _on_message(message):
	if message.get("type") == "server.hello":
		var payload = message.get("payload", {})
		status_label.text = "Servidor: " + str(payload.get("name", "")) + " " + str(payload.get("version", "")) + "\nClique no chão para mover."
