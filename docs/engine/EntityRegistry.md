# EntityRegistry

`EntityRegistry` loads entity definitions from `res://assets/entity_registry.json`.

It exposes:

- `load_registry(path)`
- `has_entity(type_id)`
- `get_definition(type_id)`
- `get_entity(type_id)`
- `get_model_path(type_id)`
- `get_kind(type_id)`
- `get_scale(type_id)`
- `list_types()`

Definitions describe placeholder rendering data now and can later point at imported models.
