extends Node

## Keeps the client-side visual world synchronized with authoritative snapshots.

var entities := {}
var target_positions := {}
var target_rotations := {}
var world_root: Node3D = null
var interpolation_speed := 12.0
var teleport_distance := 8.0
var last_snapshot_server_time := 0
var last_snapshot_local_msec := 0
var snapshot_rate := 0.0
var _snapshot_counter := 0
var _rate_window_started_msec := 0

func _ready() -> void:
	_rate_window_started_msec = Time.get_ticks_msec()

func _process(delta: float) -> void:
	for entity_id in entities.keys():
		var node: Node3D = entities.get(entity_id, null)
		if node == null or not is_instance_valid(node):
			continue

		var target_position: Vector3 = target_positions.get(entity_id, node.position)
		var distance := node.position.distance_to(target_position)
		if distance > teleport_distance:
			node.position = target_position
		else:
			node.position = node.position.lerp(target_position, clamp(delta * interpolation_speed, 0.0, 1.0))

		var target_rotation: Vector3 = target_rotations.get(entity_id, node.rotation)
		node.rotation = node.rotation.lerp(target_rotation, clamp(delta * interpolation_speed, 0.0, 1.0))

func set_world_root(root: Node3D) -> void:
	world_root = root

func apply_snapshot(snapshot: Dictionary) -> void:
	var payload = snapshot.get("payload", snapshot)
	if typeof(payload) != TYPE_DICTIONARY:
		push_error("[WorldManager] Snapshot payload must be a Dictionary.")
		return

	var snapshot_entities = payload.get("entities", [])
	if typeof(snapshot_entities) != TYPE_ARRAY:
		push_error("[WorldManager] Snapshot entities must be an Array.")
		return

	last_snapshot_server_time = int(payload.get("serverTime", 0))
	last_snapshot_local_msec = Time.get_ticks_msec()
	_update_snapshot_rate()

	var alive_ids := {}
	for entity_data in snapshot_entities:
		if typeof(entity_data) != TYPE_DICTIONARY:
			continue

		var entity_id := str(entity_data.get("id", ""))
		if entity_id.is_empty():
			continue

		alive_ids[entity_id] = true
		spawn_or_update_entity(entity_data)

	for entity_id in entities.keys():
		if not alive_ids.has(entity_id):
			remove_entity(entity_id)

func spawn_or_update_entity(entity_data: Dictionary) -> void:
	var entity_id := str(entity_data.get("id", ""))
	var entity_type := str(entity_data.get("type", ""))

	if entity_id.is_empty():
		push_error("[WorldManager] Entity data without id.")
		return

	if entity_type.is_empty():
		push_error("[WorldManager] Entity data without type for id: " + entity_id)
		return

	var node: Node3D = entities.get(entity_id, null)
	var position := _vector_from_dictionary(entity_data.get("position", Vector3.ZERO))
	var rotation := _vector_from_dictionary(entity_data.get("rotation", Vector3.ZERO))

	if node == null:
		node = EntityFactory.create_entity(entity_type, entity_id)
		if node == null:
			push_error("[WorldManager] Failed to create entity: " + entity_type)
			return

		node.name = "Entity_" + entity_id
		_get_world_root().add_child(node)
		entities[entity_id] = node
		node.position = position
		node.rotation = rotation

	node.set_meta("entity_id", entity_id)
	node.set_meta("entity_type", entity_type)
	node.set_meta("faction", str(entity_data.get("faction", node.get_meta("faction", ""))))
	target_positions[entity_id] = position
	target_rotations[entity_id] = rotation

func remove_entity(entity_id: String) -> void:
	if not entities.has(entity_id):
		return

	var node = entities[entity_id]
	if is_instance_valid(node):
		node.queue_free()
	entities.erase(entity_id)
	target_positions.erase(entity_id)
	target_rotations.erase(entity_id)

func clear_world() -> void:
	for entity_id in entities.keys():
		remove_entity(entity_id)
	entities.clear()
	target_positions.clear()
	target_rotations.clear()

func has_entity(entity_id: String) -> bool:
	return entities.has(entity_id)

func get_entity(entity_id: String) -> Node3D:
	return entities.get(entity_id, null)

func get_rendered_entity_count() -> int:
	return entities.size()

func get_last_snapshot_time() -> int:
	return last_snapshot_server_time

func get_snapshot_rate() -> float:
	return snapshot_rate

func get_approx_ping_ms() -> int:
	if last_snapshot_server_time <= 0:
		return 0

	return max(0, Time.get_ticks_msec() - last_snapshot_local_msec)

func get_local_player_position() -> Vector3:
	var player := get_entity("player_1")
	return player.global_position if player != null else Vector3.ZERO

func apply_snapshot_batch(snapshots: Array) -> void:
	apply_snapshot({ "payload": { "entities": snapshots } })

func _vector_from_dictionary(value) -> Vector3:
	if typeof(value) == TYPE_VECTOR3:
		return value

	if typeof(value) == TYPE_DICTIONARY:
		return Vector3(
			float(value.get("x", 0.0)),
			float(value.get("y", 0.0)),
			float(value.get("z", 0.0))
		)

	if typeof(value) == TYPE_ARRAY and value.size() >= 3:
		return Vector3(float(value[0]), float(value[1]), float(value[2]))

	return Vector3.ZERO

func _update_snapshot_rate() -> void:
	_snapshot_counter += 1
	var now := Time.get_ticks_msec()
	var elapsed := now - _rate_window_started_msec
	if elapsed < 1000:
		return

	snapshot_rate = float(_snapshot_counter) / (float(elapsed) / 1000.0)
	_snapshot_counter = 0
	_rate_window_started_msec = now

func _get_world_root() -> Node3D:
	if world_root != null and is_instance_valid(world_root):
		return world_root

	var fallback := Node3D.new()
	fallback.name = "WorldRoot"
	get_tree().current_scene.add_child(fallback)
	world_root = fallback
	return world_root
