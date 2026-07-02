extends CanvasLayer

var panel: Panel = null
var label: Label = null

func _ready() -> void:
	visible = false
	layer = 100
	_build_ui()

func toggle() -> void:
	visible = not visible

func _process(_delta: float) -> void:
	if not visible or label == null:
		return

	var player_position := WorldManager.get_local_player_position()
	label.text = "Elysium Debug\n"
	label.text += "Connection: " + NetworkManager.connection_status() + "\n"
	label.text += "Entities: " + str(WorldManager.get_rendered_entity_count()) + "\n"
	label.text += "Last snapshot: " + str(WorldManager.get_last_snapshot_time()) + "\n"
	label.text += "Snapshot rate: " + str(snapped(WorldManager.get_snapshot_rate(), 0.1)) + " /s\n"
	label.text += "Player: " + str(player_position) + "\n"
	label.text += "Selected: " + SelectionManager.get_selected_entity_id() + "\n"
	label.text += "Approx ping: " + str(WorldManager.get_approx_ping_ms()) + " ms"

func _build_ui() -> void:
	panel = Panel.new()
	panel.name = "DebugPanel"
	panel.position = Vector2(16.0, 144.0)
	panel.size = Vector2(360.0, 170.0)
	add_child(panel)

	label = Label.new()
	label.position = Vector2(12.0, 10.0)
	label.size = Vector2(336.0, 150.0)
	panel.add_child(label)
