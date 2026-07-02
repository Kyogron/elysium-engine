# Sprint 3.4 — WorldManager

## Instalação

1. Garanta que `develop` contém as Sprints 3.1, 3.2 e 3.3.
2. Crie a branch:

```bash
git checkout develop
git pull
git checkout -b feature/world-manager
```

3. Extraia este pacote na raiz do repositório.

4. No arquivo `client/godot/project.godot`, adicione em `[autoload]`:

```ini
WorldManager="*res://core/world/WorldManager.gd"
```

5. Abra o Godot e confirme que não há erro no console.

## Commit

```bash
git status
git add .
git commit -m "Sprint 3.4 - Add WorldManager"
git push -u origin feature/world-manager
```

## Merge para develop

```bash
git checkout develop
git merge feature/world-manager
git push origin develop
```
