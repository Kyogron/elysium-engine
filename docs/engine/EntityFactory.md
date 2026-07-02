# EntityFactory

`EntityFactory` creates `Node3D` instances from entity types.

It reads definitions from `EntityRegistry`. If a future `model` path exists, the factory can instantiate that `PackedScene`. If no model exists, it creates a procedural placeholder mesh using the registry shape, color and scale.

Current placeholder shapes:

- `capsule`
- `box`
- `cylinder`

Main API:

```gdscript
func create_entity(entity_type: String, entity_id: String = "") -> Node3D
```
