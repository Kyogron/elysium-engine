extends Node

signal selection_changed(entity_id: String)

var selected_entity: Node3D = null
var marker: MeshInstance3D = null

func select_entity(entity: Node3D) -> void:
	if selected_entity == entity:
		return

	clear_selection()
	selected_entity = entity
	_attach_marker(entity)
	selection_changed.emit(str(entity.get_meta("entity_id", "")))

func clear_selection() -> void:
	if marker != null and is_instance_valid(marker):
		marker.queue_free()

	marker = null
	selected_entity = null
	selection_changed.emit("")

func get_selected_entity_id() -> String:
	if selected_entity == null or not is_instance_valid(selected_entity):
		return ""

	return str(selected_entity.get_meta("entity_id", ""))

func _attach_marker(entity: Node3D) -> void:
	marker = MeshInstance3D.new()
	marker.name = "SelectionRing"

	var torus := TorusMesh.new()
	torus.inner_radius = 0.52
	torus.outer_radius = 0.62
	marker.mesh = torus
	marker.rotation_degrees = Vector3(90.0, 0.0, 0.0)
	marker.position = Vector3(0.0, 0.04, 0.0)

	var material := StandardMaterial3D.new()
	material.albedo_color = Color(0.25, 0.75, 1.0, 1.0)
	material.emission_enabled = true
	material.emission = Color(0.15, 0.55, 1.0)
	marker.material_override = material

	entity.add_child(marker)
