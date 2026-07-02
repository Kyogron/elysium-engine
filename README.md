# Elysium Engine

Elysium Engine is the technical foundation for an authoritative MOBA with a Godot client, a TypeScript WebSocket server and future PostgreSQL support.

## Alpha 0.2

This version provides the first runnable engine loop:

- Godot 4.7 client bootstrap at `client/godot`.
- Procedural `WorldRoot`, ground, light, camera and input.
- Runtime entity creation through `EntityRegistry`, `EntityFactory` and `WorldManager`.
- WebSocket server snapshots with `world.snapshot` every 100ms.
- Authoritative `player.move` handling for `player_1`.

## Run Server

```bash
cd server
npm install
npm run dev
```

The server listens on `ws://localhost:8080` by default.

## Run Client

Open `client/godot/project.godot` in Godot 4.7+ and run the main scene.

## Structure

- `client/godot` - official Godot client.
- `server` - authoritative TypeScript WebSocket server.
- `shared` - shared protocol/config/math space.
- `database` - future migrations, schema and seeds.
- `assets` - source assets for characters, environment, materials, textures, UI and audio.
- `docs` - engine documentation.
