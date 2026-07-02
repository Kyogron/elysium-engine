# Asset Pipeline

## Goal
Assets must be created once, organized clearly, and loaded automatically by the engine.

## Flow
```txt
Blender -> GLB -> assets/ -> ResourceManager -> EntityFactory -> WorldManager
```

## Folders
```txt
assets/characters/champions/{champion_id}/model.glb
assets/characters/minions/{minion_id}/model.glb
assets/environment/structures/{structure_id}/model.glb
assets/environment/maps/{map_id}/
assets/ui/
assets/audio/
```

## Rule
No random asset paths inside gameplay code. Assets are referenced by registry IDs.
