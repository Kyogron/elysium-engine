# Network Protocol

## Early Stage
Use JSON for readability and fast iteration.

## Later Stage
Migrate to binary protocol when snapshots become large.

## Packet Format
```json
{
  "type": "domain.action",
  "payload": {}
}
```

## Client Commands
- player.move
- player.attack
- player.cast_skill
- client.ready

## Server Events
- server.hello
- world.snapshot
- match.state
- entity.spawned
- entity.removed
- error.message
