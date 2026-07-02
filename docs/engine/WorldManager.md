# WorldManager

`WorldManager` owns the client-side map of `entity_id -> Node3D`.

It receives snapshots from `SnapshotReceiver`, creates missing entities through `EntityFactory`, updates positions and rotations, and removes entities that disappear from the latest snapshot.

Main API:

```gdscript
func set_world_root(root: Node3D) -> void
func apply_snapshot(snapshot: Dictionary) -> void
func spawn_or_update_entity(entity_data: Dictionary) -> void
func remove_entity(entity_id: String) -> void
func clear_world() -> void
```
