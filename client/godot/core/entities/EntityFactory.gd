extends Node

func create_entity(entity_type: String, entity_id: String = "") -> Node3D:
	if not EntityRegistry.has_entity(entity_type):
		push_error("[EntityFactory] Tipo de entidade não registrado: " + entity_type)
		return null

	var definition = EntityRegistry.get_entity(entity_type)
	var scene_path = definition.get("scene", "")

	if scene_path == "":
		push_error("[EntityFactory] Entidade sem scene: " + entity_type)
		return null

	var resource = ResourceManager.load_resource(scene_path)
	if resource == null:
		push_error("[EntityFactory] Falha ao carregar scene: " + scene_path)
		return null

	if not resource is PackedScene:
		push_error("[EntityFactory] Recurso não é PackedScene: " + scene_path)
		return null

	var instance = resource.instantiate()
	if not instance is Node3D:
		push_error("[EntityFactory] Instância não é Node3D: " + scene_path)
		return null

	instance.name = entity_id if entity_id != "" else entity_type
	instance.set_meta("entity_type", entity_type)
	instance.set_meta("entity_id", entity_id)

	var scale_value = float(definition.get("scale", 1.0))
	instance.scale = Vector3.ONE * scale_value

	return instance
