extends Node

const REGISTRY_PATH := "res://assets/registry/entities.json"

var _definitions := {}
var _loaded := false

func _ready():
	load_registry()

func load_registry(path: String = REGISTRY_PATH) -> bool:
	_definitions.clear()
	_loaded = false

	if not FileAccess.file_exists(path):
		push_error("[EntityRegistry] Registry não encontrado: " + path)
		return false

	var file := FileAccess.open(path, FileAccess.READ)
	if file == null:
		push_error("[EntityRegistry] Falha ao abrir registry: " + path)
		return false

	var text := file.get_as_text()
	var parsed = JSON.parse_string(text)

	if typeof(parsed) != TYPE_DICTIONARY:
		push_error("[EntityRegistry] JSON inválido em: " + path)
		return false

	_definitions = parsed
	_loaded = true
	print("[EntityRegistry] Entidades carregadas: ", _definitions.size())
	return true

func is_loaded() -> bool:
	return _loaded

func has_entity(type_id: String) -> bool:
	return _definitions.has(type_id)

func get_definition(type_id: String) -> Dictionary:
	if not _definitions.has(type_id):
		push_error("[EntityRegistry] Tipo de entidade não registrado: " + type_id)
		return {}

	return _definitions[type_id]

func get_model_path(type_id: String) -> String:
	var definition := get_definition(type_id)
	return str(definition.get("model", ""))

func get_kind(type_id: String) -> String:
	var definition := get_definition(type_id)
	return str(definition.get("kind", "unknown"))

func get_scale(type_id: String) -> float:
	var definition := get_definition(type_id)
	return float(definition.get("scale", 1.0))

func list_types() -> Array:
	return _definitions.keys()
