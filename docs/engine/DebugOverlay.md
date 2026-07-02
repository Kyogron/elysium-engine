# Debug Overlay

`DebugOverlay` is a procedural Godot autoload toggled with `F3`.

It displays:

- connection status
- rendered entity count
- latest snapshot server time
- approximate snapshot rate
- local player position
- selected entity id
- approximate time since the latest snapshot arrived

The overlay is intentionally lightweight and reads state from existing managers instead of owning gameplay logic.
