extends Node3D

## WorldManager
## Keeps the client-side visual world synchronized with server/entity snapshots.
## It does not own gameplay rules; the server remains authoritative.

var entities := {}

func clear_world() -> void:
	for entity_id in entities.keys():
		var node = entities[entity_id]
		if is_instance_valid(node):
			node.queue_free()
	entities.clear()

func has_entity(entity_id) -> bool:
	return entities.has(str(entity_id))

func get_entity(entity_id) -> Node3D:
	return entities.get(str(entity_id), null)

func spawn_entity(snapshot: Dictionary) -> Node3D:
	var entity_id := str(snapshot.get("id", ""))
	var entity_type := str(snapshot.get("type", ""))

	if entity_id.is_empty():
		push_error("[WorldManager] Snapshot sem id.")
		return null

	if entity_type.is_empty():
		push_error("[WorldManager] Snapshot sem type para id: " + entity_id)
		return null

	if has_entity(entity_id):
		return get_entity(entity_id)

	var node = EntityFactory.create_entity(entity_type)
	if node == null:
		push_error("[WorldManager] Falha ao criar entidade: " + entity_type)
		return null

	node.name = "Entity_" + entity_id + "_" + entity_type
	add_child(node)
	entities[entity_id] = node
	apply_snapshot_to_node(node, snapshot)
	return node

func remove_entity(entity_id) -> void:
	var key := str(entity_id)
	if not entities.has(key):
		return

	var node = entities[key]
	if is_instance_valid(node):
		node.queue_free()
	entities.erase(key)

func apply_snapshot(snapshot: Dictionary) -> void:
	var entity_id := str(snapshot.get("id", ""))
	if entity_id.is_empty():
		push_error("[WorldManager] Snapshot sem id.")
		return

	var node = get_entity(entity_id)
	if node == null:
		node = spawn_entity(snapshot)
		return

	apply_snapshot_to_node(node, snapshot)

func apply_snapshot_batch(snapshots: Array) -> void:
	var alive_ids := {}

	for snapshot in snapshots:
		if typeof(snapshot) != TYPE_DICTIONARY:
			continue

		var entity_id := str(snapshot.get("id", ""))
		if entity_id.is_empty():
			continue

		alive_ids[entity_id] = true
		apply_snapshot(snapshot)

	var current_ids := entities.keys()
	for entity_id in current_ids:
		if not alive_ids.has(entity_id):
			remove_entity(entity_id)

func apply_snapshot_to_node(node: Node3D, snapshot: Dictionary) -> void:
	if snapshot.has("position"):
		var pos = snapshot.get("position")
		if typeof(pos) == TYPE_ARRAY and pos.size() >= 3:
			node.position = Vector3(float(pos[0]), float(pos[1]), float(pos[2]))

	if snapshot.has("rotation_y"):
		node.rotation.y = float(snapshot.get("rotation_y"))

	if snapshot.has("scale"):
		var s = float(snapshot.get("scale"))
		node.scale = Vector3(s, s, s)
