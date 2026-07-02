# Movement System

Movement remains server-authoritative.

Client flow:

- Right-click emits a desired target.
- The client sends `player.move`.
- The local player is not moved authoritatively on the client.
- `WorldManager` smooths visual movement toward snapshot targets.

Server flow:

- `WebSocketGateway` validates `player.move` payloads.
- `WorldState` stores the movement target for `player_1`.
- `MovementSystem` clamps the target to map bounds.
- `MovementSystem` moves the entity toward the target during snapshot updates.
- `SnapshotSystem` broadcasts the resulting authoritative state.

Client interpolation is intentionally simple for Alpha 0.3: each entity keeps a latest target position and target rotation from snapshots, and its visible transform lerps toward those targets. Large gaps teleport to avoid long visual catch-up after stalls.
