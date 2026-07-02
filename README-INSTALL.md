# Sprint 3.3 — EntityFactory

## Instalação

Extraia este pacote na raiz do repositório.

Depois adicione no `client/godot/project.godot`, em `[autoload]`:

```ini
EntityFactory="*res://core/entities/EntityFactory.gd"
```

## Teste

Abra o Godot e confira se não aparecem erros.

Na próxima sprint, o `WorldManager` usará a `EntityFactory` para criar entidades automaticamente a partir de snapshots.
