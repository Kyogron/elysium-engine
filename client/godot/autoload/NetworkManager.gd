extends Node

signal connected_to_server
signal disconnected_from_server
signal message_received(message)

var socket := WebSocketPeer.new()
var connected := false
var server_url := "ws://localhost:8080"

func connect_to_server(url := server_url):
	server_url = url
	var err := socket.connect_to_url(server_url)
	if err != OK:
		push_error("Erro ao conectar: " + str(err))
		return

func _process(_delta):
	socket.poll()
	var state := socket.get_ready_state()

	if state == WebSocketPeer.STATE_OPEN:
		if not connected:
			connected = true
			connected_to_server.emit()
		while socket.get_available_packet_count() > 0:
			var text := socket.get_packet().get_string_from_utf8()
			var data = JSON.parse_string(text)
			if typeof(data) == TYPE_DICTIONARY:
				message_received.emit(data)
	elif state == WebSocketPeer.STATE_CLOSED:
		if connected:
			connected = false
			disconnected_from_server.emit()

func send_message(type, payload := {}):
	if socket.get_ready_state() != WebSocketPeer.STATE_OPEN:
		return
	var message := { "type": type, "payload": payload }
	socket.send_text(JSON.stringify(message))
