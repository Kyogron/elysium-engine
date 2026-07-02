# Shared Protocol

Alpha 0.3 keeps protocol types in the TypeScript server and documents the cross-client contract here.

Message envelope:

```json
{
  "type": "message.type",
  "payload": {}
}
```

Current messages:

- `server.hello`
- `world.snapshot`
- `player.move`

The authoritative reference is `docs/engine/Protocol.md`.
