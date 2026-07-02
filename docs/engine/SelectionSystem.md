# Selection System

`SelectionManager` owns entity selection feedback.

Decision:

- Entity creation remains centralized in `EntityFactory`.
- `EntityFactory` attaches a procedural `StaticBody3D` selection collider to each entity.
- `InputController` performs the left-click raycast and asks `SelectionManager` to select the hit entity.
- `SelectionManager` attaches a procedural ring marker to the selected entity.
- `ESC` clears the current selection.

This keeps selection visuals out of `WorldManager` and avoids manual editor setup.
