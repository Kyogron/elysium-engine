# Codex Tasks

## Alpha 0.2 Completed

- Added missing Godot autoloads for snapshots, camera and input.
- Converted main scene into procedural bootstrap.
- Added procedural entity registry data.
- Updated entity creation to support placeholders without manual scenes.
- Updated world synchronization around `world.snapshot`.
- Replaced echo server with authoritative TypeScript WebSocket server.
- Added snapshot broadcasting at 100ms.
- Added server-side `player.move` handling for `player_1`.

## Next

- Alpha 0.3: camera polish, edge scrolling, selection and navigation feedback.
- Alpha 0.4: original asset pipeline and `.glb` model support.
- Alpha 0.5: gameplay core with minions, towers, health and basic combat.
