extends Node

var camera: Camera3D = null

func setup(active_camera: Camera3D) -> void:
	camera = active_camera

func _unhandled_input(event: InputEvent) -> void:
	if not (event is InputEventMouseButton):
		return

	if event.button_index != MOUSE_BUTTON_RIGHT or not event.pressed:
		return

	var hit := _raycast_ground(event.position)
	if hit.is_empty():
		return

	var target: Vector3 = hit["position"]
	NetworkManager.send_message("player.move", {
		"target": {
			"x": target.x,
			"y": target.y,
			"z": target.z
		}
	})

func _raycast_ground(mouse_pos: Vector2) -> Dictionary:
	if camera == null:
		return {}

	var space_state := camera.get_world_3d().direct_space_state
	var ray_origin := camera.project_ray_origin(mouse_pos)
	var ray_end := ray_origin + camera.project_ray_normal(mouse_pos) * 1000.0
	var query := PhysicsRayQueryParameters3D.create(ray_origin, ray_end)
	query.collide_with_areas = true
	query.collide_with_bodies = true
	return space_state.intersect_ray(query)
