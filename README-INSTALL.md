# Sprint 3.2 — Entity Registry

## Instalação

1. Extraia este pacote na raiz do repositório.
2. Abra `client/godot/project.godot`.
3. Em `[autoload]`, adicione:

```ini
EntityRegistry="*res://core/entities/EntityRegistry.gd"
```

O bloco deve ficar parecido com:

```ini
[autoload]
NetworkManager="*res://autoload/NetworkManager.gd"
ResourceManager="*res://core/resources/ResourceManager.gd"
EntityRegistry="*res://core/entities/EntityRegistry.gd"
```

## Teste

Abra o projeto no Godot e rode. No console, deve aparecer:

```txt
[EntityRegistry] Entidades carregadas: 3
```

## Commit sugerido

```bash
git add .
git commit -m "Sprint 3.2 - Add EntityRegistry"
git push -u origin feature/entity-registry
```
