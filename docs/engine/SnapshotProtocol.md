# Snapshot Protocol

The authoritative server sends `world.snapshot` messages every 100ms.

```json
{
  "type": "world.snapshot",
  "payload": {
    "serverTime": 123456,
    "entities": [
      {
        "id": "player_1",
        "type": "champion_placeholder",
        "position": { "x": 0, "y": 0, "z": 0 },
        "rotation": { "x": 0, "y": 0, "z": 0 },
        "health": { "current": 100, "max": 100 }
      }
    ]
  }
}
```

The client does not simulate authoritative movement. It applies the latest snapshot through `SnapshotReceiver` and `WorldManager`.

Client input uses `player.move`:

```json
{
  "type": "player.move",
  "payload": {
    "target": { "x": 10, "y": 0, "z": 5 }
  }
}
```
