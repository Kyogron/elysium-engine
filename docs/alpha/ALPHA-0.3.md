# Alpha 0.3 - Camera, Input and Movement Polish

Alpha 0.3 builds on the snapshot foundation from Alpha 0.2 and improves the feel of the client loop without moving authority away from the server.

## Client

- `CameraController` creates a procedural `CameraRig -> Pivot -> Camera3D` hierarchy.
- The camera follows `player_1`, uses a MOBA-style oblique angle and supports scroll-wheel zoom.
- `InputController` raycasts from the active camera.
- Right-click emits a movement request that `Main.gd` sends as `player.move`.
- Left-click selects an entity when the raycast hits an entity collider.
- `ESC` clears selection.
- `F3` toggles `DebugOverlay`.
- `SelectionManager` adds a procedural ring marker to the selected entity.
- `WorldManager` keeps authoritative snapshot targets separate from visual positions and lerps entities toward their latest server state.

## Server

- `MovementSystem` owns movement stepping and target clamping.
- `WorldState` remains the source of entity state.
- `SnapshotSystem` continues broadcasting `world.snapshot` every 100ms.
- `player.move` payloads are validated before updating the player target.
- Movement targets are clamped to simple map bounds.

## Acceptance Checks

```bash
cd server
npm install
npm run build
npm run dev
```

Open `client/godot/project.godot` in Godot 4.7+ and run the main scene.
