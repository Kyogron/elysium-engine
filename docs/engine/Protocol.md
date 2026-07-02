# Protocol

All messages use:

```json
{
  "type": "message.type",
  "payload": {}
}
```

## server.hello

Sent by the server when a WebSocket client connects.

```json
{
  "type": "server.hello",
  "payload": {
    "name": "Elysium Engine",
    "version": "0.3.0",
    "snapshotRateMs": 100
  }
}
```

## world.snapshot

Sent by the server every 100ms.

```json
{
  "type": "world.snapshot",
  "payload": {
    "serverTime": 123456,
    "entities": [
      {
        "id": "player_1",
        "type": "champion_placeholder",
        "faction": "blue",
        "position": { "x": 0, "y": 0, "z": 0 },
        "rotation": { "x": 0, "y": 0, "z": 0 },
        "health": { "current": 100, "max": 100 }
      }
    ]
  }
}
```

## player.move

Sent by the client when the player right-clicks the ground.

```json
{
  "type": "player.move",
  "payload": {
    "target": { "x": 10, "y": 0, "z": 5 }
  }
}
```

The server validates numeric coordinates and clamps the target to simple map bounds.
