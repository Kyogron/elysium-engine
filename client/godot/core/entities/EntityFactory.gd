extends Node

func create_entity(entity_type: String, entity_id: String = "") -> Node3D:
	if not EntityRegistry.has_entity(entity_type):
		push_error("[EntityFactory] Entity type not registered: " + entity_type)
		return null

	var definition: Dictionary = EntityRegistry.get_definition(entity_type)
	var model_path := str(definition.get("model", ""))

	var instance: Node3D = null
	if not model_path.is_empty() and ResourceLoader.exists(model_path):
		instance = _instantiate_model(model_path)

	if instance == null:
		instance = _create_placeholder(definition)

	instance.name = entity_id if entity_id != "" else entity_type
	instance.set_meta("entity_type", entity_type)
	instance.set_meta("entity_id", entity_id)
	instance.scale = Vector3.ONE * float(definition.get("scale", 1.0))
	return instance

func _instantiate_model(path: String) -> Node3D:
	var resource = ResourceManager.load_resource(path)
	if resource is PackedScene:
		var instance = resource.instantiate()
		if instance is Node3D:
			return instance
		push_error("[EntityFactory] PackedScene root is not Node3D: " + path)

	return null

func _create_placeholder(definition: Dictionary) -> Node3D:
	var root := Node3D.new()
	var visual := MeshInstance3D.new()
	visual.name = "Visual"
	visual.mesh = _build_mesh(str(definition.get("shape", "box")))
	visual.material_override = _build_material(str(definition.get("color", "#ffffff")))
	root.add_child(visual)
	return root

func _build_mesh(shape: String) -> Mesh:
	match shape:
		"capsule":
			var capsule := CapsuleMesh.new()
			capsule.radius = 0.45
			capsule.height = 1.6
			return capsule
		"cylinder":
			var cylinder := CylinderMesh.new()
			cylinder.top_radius = 0.5
			cylinder.bottom_radius = 0.7
			cylinder.height = 2.2
			return cylinder
		_:
			var box := BoxMesh.new()
			box.size = Vector3.ONE
			return box

func _build_material(color_text: String) -> StandardMaterial3D:
	var material := StandardMaterial3D.new()
	material.albedo_color = Color.html(color_text)
	return material
