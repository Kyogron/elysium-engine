extends Node

signal connected_to_server
signal disconnected_from_server
signal message_received(message: Dictionary)

var socket := WebSocketPeer.new()
var connected := false
var server_url := "ws://localhost:8080"
var last_connected_at_msec := 0

func connect_to_server(url := server_url) -> void:
	if socket.get_ready_state() == WebSocketPeer.STATE_OPEN or socket.get_ready_state() == WebSocketPeer.STATE_CONNECTING:
		return

	server_url = url
	var err := socket.connect_to_url(server_url)
	if err != OK:
		push_error("[NetworkManager] Failed to connect: " + str(err))

func _process(_delta: float) -> void:
	socket.poll()
	var state := socket.get_ready_state()

	if state == WebSocketPeer.STATE_OPEN:
		if not connected:
			connected = true
			last_connected_at_msec = Time.get_ticks_msec()
			connected_to_server.emit()

		while socket.get_available_packet_count() > 0:
			var text := socket.get_packet().get_string_from_utf8()
			var data = JSON.parse_string(text)
			if typeof(data) == TYPE_DICTIONARY:
				message_received.emit(data)
			else:
				push_warning("[NetworkManager] Ignored non-JSON message: " + text)
	elif state == WebSocketPeer.STATE_CLOSED:
		if connected:
			connected = false
			disconnected_from_server.emit()

func send_message(type: String, payload: Dictionary = {}) -> void:
	if socket.get_ready_state() != WebSocketPeer.STATE_OPEN:
		return

	socket.send_text(JSON.stringify({
		"type": type,
		"payload": payload
	}))

func connection_status() -> String:
	if connected:
		return "connected"

	match socket.get_ready_state():
		WebSocketPeer.STATE_CONNECTING:
			return "connecting"
		WebSocketPeer.STATE_CLOSING:
			return "closing"
		WebSocketPeer.STATE_CLOSED:
			return "closed"
		_:
			return "unknown"
