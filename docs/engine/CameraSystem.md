# Camera System

`CameraController` creates the runtime MOBA camera. It does not rely on a manually placed camera in the scene.

Runtime hierarchy:

```txt
CameraRig
└── Pivot
    └── Camera3D
```

Behavior:

- `CameraRig` follows the local player entity, currently `player_1`.
- `CameraRig` controls yaw, currently around `45` degrees.
- `Pivot` controls pitch, currently around `-55` degrees.
- `Camera3D` sits at a zoomable distance from the pivot.
- Mouse wheel zoom clamps between minimum and maximum distances.

The rig structure is intentionally ready for later edge scrolling, spectator camera modes and replay camera controls.
