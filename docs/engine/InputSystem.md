# Input System

`InputController` listens for right-clicks on the ground.

When a raycast hits the ground collider it sends a `player.move` message through `NetworkManager`.

The client does not move the champion locally. Movement appears only when the server updates entity positions in `world.snapshot`.
