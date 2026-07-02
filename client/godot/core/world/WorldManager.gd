extends Node

## Keeps the client-side visual world synchronized with authoritative snapshots.

var entities := {}
var world_root: Node3D = null

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
	if node == null:
		node = EntityFactory.create_entity(entity_type, entity_id)
		if node == null:
			push_error("[WorldManager] Failed to create entity: " + entity_type)
			return

		node.name = "Entity_" + entity_id
		_get_world_root().add_child(node)
		entities[entity_id] = node

	_apply_entity_state(node, entity_data)

func remove_entity(entity_id: String) -> void:
	if not entities.has(entity_id):
		return

	var node = entities[entity_id]
	if is_instance_valid(node):
		node.queue_free()
	entities.erase(entity_id)

func clear_world() -> void:
	for entity_id in entities.keys():
		remove_entity(entity_id)
	entities.clear()

func has_entity(entity_id: String) -> bool:
	return entities.has(entity_id)

func get_entity(entity_id: String) -> Node3D:
	return entities.get(entity_id, null)

func apply_snapshot_batch(snapshots: Array) -> void:
	apply_snapshot({ "payload": { "entities": snapshots } })

func _apply_entity_state(node: Node3D, entity_data: Dictionary) -> void:
	if entity_data.has("position"):
		node.position = _vector_from_dictionary(entity_data["position"])

	if entity_data.has("rotation"):
		node.rotation = _vector_from_dictionary(entity_data["rotation"])

func _vector_from_dictionary(value) -> Vector3:
	if typeof(value) == TYPE_DICTIONARY:
		return Vector3(
			float(value.get("x", 0.0)),
			float(value.get("y", 0.0)),
			float(value.get("z", 0.0))
		)

	if typeof(value) == TYPE_ARRAY and value.size() >= 3:
		return Vector3(float(value[0]), float(value[1]), float(value[2]))

	return Vector3.ZERO

func _get_world_root() -> Node3D:
	if world_root != null and is_instance_valid(world_root):
		return world_root

	var fallback := Node3D.new()
	fallback.name = "WorldRoot"
	get_tree().current_scene.add_child(fallback)
	world_root = fallback
	return world_root
