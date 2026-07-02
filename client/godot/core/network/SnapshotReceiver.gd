extends Node

func _ready() -> void:
	NetworkManager.message_received.connect(_on_message_received)

func _on_message_received(message: Dictionary) -> void:
	if str(message.get("type", "")) != "world.snapshot":
		return

	WorldManager.apply_snapshot(message)
