# Alpha 0.2 - Engine Foundation

Alpha 0.2 turns Elysium Engine into a runnable client/server foundation for an authoritative 3D MOBA.

## Client

- Godot 4.7 project at `client/godot/project.godot`.
- Main scene is a small bootstrap that creates light, ground, `WorldRoot`, camera and UI.
- Runtime entities are created by `WorldManager` from server snapshots.
- Right-clicking the ground sends `player.move` to the server.

## Server

- TypeScript WebSocket server at `server/`.
- `npm run dev` starts a local server on `ws://localhost:8080`.
- The server sends `server.hello` on connection.
- The server broadcasts `world.snapshot` every 100ms.
- `player_1` moves gradually toward the latest `player.move` target.

## Run

```bash
cd server
npm install
npm run dev
```

Open `client/godot/project.godot` in Godot and run the main scene.
