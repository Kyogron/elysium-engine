extends Node

## Elysium Engine ResourceManager
## Centralized runtime resource loading and caching for the Godot client.

var _cache: Dictionary = {}

func load_resource(path: String) -> Resource:
	if path.is_empty():
		push_error("[ResourceManager] Empty resource path.")
		return null

	if _cache.has(path):
		return _cache[path]

	if not ResourceLoader.exists(path):
		push_error("[ResourceManager] Resource not found: " + path)
		return null

	var resource: Resource = ResourceLoader.load(path)
	if resource == null:
		push_error("[ResourceManager] Failed to load resource: " + path)
		return null

	_cache[path] = resource
	return resource

func load_scene(path: String) -> PackedScene:
	var resource := load_resource(path)
	if resource is PackedScene:
		return resource

	push_error("[ResourceManager] Resource is not a PackedScene: " + path)
	return null

func instantiate_scene(path: String) -> Node:
	var scene := load_scene(path)
	if scene == null:
		return null

	return scene.instantiate()

func has_cached(path: String) -> bool:
	return _cache.has(path)

func unload_resource(path: String) -> void:
	if _cache.has(path):
		_cache.erase(path)

func clear_cache() -> void:
	_cache.clear()

func cache_size() -> int:
	return _cache.size()

func debug_cache_keys() -> Array:
	return _cache.keys()
