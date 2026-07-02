# Elysium Engine — Technical Architecture

## Vision
Elysium Engine is a reusable MOBA-focused game engine framework built around an authoritative server, a Godot 4 client, PostgreSQL persistence, and a strict separation between engine systems and game-specific content.

## Roles
- Engine: networking, ECS, resources, world state, rendering bridge, camera, input, UI framework, asset pipeline, logging, tools.
- Game: champions, abilities, items, maps, balance, lore, progression, matchmaking rules, cosmetics.

## Stack
- Client: Godot 4.x, GDScript initially, optional C# later for tooling/performance hotspots.
- Server: Node.js + TypeScript.
- Database: PostgreSQL.
- Network: WebSocket JSON during early development; binary protocol later.
- Assets: Blender -> GLB -> Godot ResourceManager.

## Repository Layout
```txt
elysium-engine/
├─ .github/
├─ .vscode/
├─ assets/
│  ├─ characters/
│  │  ├─ champions/
│  │  ├─ minions/
│  │  └─ monsters/
│  ├─ environment/
│  │  ├─ maps/
│  │  ├─ props/
│  │  └─ structures/
│  ├─ materials/
│  ├─ textures/
│  ├─ audio/
│  ├─ ui/
│  └─ shaders/
├─ client/
│  └─ godot/
├─ server/
├─ shared/
├─ database/
├─ docs/
├─ tools/
├─ tests/
└─ scripts/
```

## Client Architecture
```txt
client/godot/
├─ core/
│  ├─ resources/
│  ├─ networking/
│  ├─ entities/
│  ├─ world/
│  ├─ camera/
│  ├─ input/
│  ├─ ui/
│  └─ debug/
├─ game/
│  ├─ champions/
│  ├─ maps/
│  └─ modes/
├─ scenes/
├─ autoload/
└─ project.godot
```

Core systems must be reusable. Game systems may depend on core, but core must never depend on game-specific content.

## Server Architecture
```txt
server/src/
├─ config/
├─ gateway/
├─ auth/
├─ match/
├─ world/
├─ ecs/
├─ combat/
├─ skills/
├─ ai/
├─ database/
├─ protocol/
└─ utils/
```

The server is authoritative. The client sends intent; the server decides the result.

## Networking Rule
Client sends commands:
```json
{ "type": "player.move", "payload": { "x": 10, "z": 4 } }
```
Server sends snapshots:
```json
{ "type": "world.snapshot", "payload": { "tick": 120, "entities": [] } }
```

## ECS Rule
Everything in gameplay is an entity: players, minions, towers, bases, projectiles, jungle monsters, wards, summons.

Components hold data. Systems hold logic.

## Asset Pipeline
Blender exports `.glb` files into `assets/`. Godot loads them through ResourceManager and EntityFactory. No gameplay script should directly preload models.

## Naming
- Files: snake_case.
- Classes/systems: PascalCase.
- Network packet types: domain.action, e.g. `world.snapshot`, `player.cast_skill`.
- Asset IDs: lowercase snake_case, e.g. `tower_blue_a01`.

## Development Flow
- `main`: stable releases.
- `develop`: integration branch.
- `feature/*`: individual systems.
- Each sprint ends with documentation, test instructions, and a commit.
