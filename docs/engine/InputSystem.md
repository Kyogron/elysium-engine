# Input System

`InputController` converts local player input into engine-level intent.

Controls:

- Right-click raycasts from the camera and emits `move_requested(target)`.
- `Main.gd` listens for `move_requested` and sends `player.move` through `NetworkManager`.
- Left-click raycasts for entity colliders and selects entities through `SelectionManager`.
- `ESC` clears selection.
- `F3` toggles `DebugOverlay`.

The controller avoids directly deciding authoritative movement. It detects player intent; the server decides the resulting state.
