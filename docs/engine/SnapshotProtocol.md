# Snapshot Protocol

`world.snapshot` is the server-to-client state message used by the Godot client.

Snapshots are broadcast every 100ms and remain the source of truth for visible entities. The client stores target transforms from snapshots and interpolates visuals toward them.

See `docs/engine/Protocol.md` for all message shapes.
