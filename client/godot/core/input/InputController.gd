extends Node

signal move_requested(target: Vector3)

var camera: Camera3D = null

func setup(active_camera: Camera3D) -> void:
	camera = active_camera

func _unhandled_input(event: InputEvent) -> void:
	if event is InputEventKey and event.pressed:
		if event.keycode == KEY_ESCAPE:
			SelectionManager.clear_selection()
		elif event.keycode == KEY_F3:
			DebugOverlay.toggle()
		return

	if not (event is InputEventMouseButton) or not event.pressed:
		return

	if event.button_index == MOUSE_BUTTON_RIGHT:
		_handle_move_click(event.position)
	elif event.button_index == MOUSE_BUTTON_LEFT:
		_handle_select_click(event.position)

func _handle_move_click(mouse_pos: Vector2) -> void:
	var hit := _raycast(mouse_pos)
	if hit.is_empty():
		return

	var target: Vector3 = hit["position"]
	move_requested.emit(target)

func _handle_select_click(mouse_pos: Vector2) -> void:
	var hit := _raycast(mouse_pos)
	if hit.is_empty():
		SelectionManager.clear_selection()
		return

	var collider = hit.get("collider")
	var entity := _find_entity_node(collider)
	if entity == null:
		SelectionManager.clear_selection()
		return

	SelectionManager.select_entity(entity)

func _raycast(mouse_pos: Vector2) -> Dictionary:
	if camera == null:
		return {}

	var space_state := camera.get_world_3d().direct_space_state
	var ray_origin := camera.project_ray_origin(mouse_pos)
	var ray_end := ray_origin + camera.project_ray_normal(mouse_pos) * 1000.0
	var query := PhysicsRayQueryParameters3D.create(ray_origin, ray_end)
	query.collide_with_areas = true
	query.collide_with_bodies = true
	return space_state.intersect_ray(query)

func _find_entity_node(node) -> Node3D:
	var current = node
	while current != null:
		if current is Node3D and current.has_meta("entity_id"):
			return current
		current = current.get_parent() if current is Node else null

	return null
