# ResourceManager

`ResourceManager` centralizes runtime resource loading for the Godot client.

It keeps a cache and avoids spreading `preload()` calls through gameplay systems.

Required API:

- `load_resource(path)`
- `has_cached(path)`
- `unload_resource(path)`
- `clear_cache()`
- `cache_size()`

It also includes helpers for scenes: `load_scene(path)` and `instantiate_scene(path)`.
