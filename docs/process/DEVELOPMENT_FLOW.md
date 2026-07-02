# Development Flow

## Branches
- main: stable and tested.
- develop: active integration.
- feature/name: individual sprint or system work.

## Standard Sprint Flow
```bash
git checkout develop
git pull
git checkout -b feature/name
```

After testing:
```bash
git status
git add .
git commit -m "Sprint X - Description"
git push -u origin feature/name
```

Merge only after the sprint works locally.

## Sprint Completion Checklist
- Code compiles.
- Godot opens without errors.
- Server starts without errors.
- Feature tested manually.
- Documentation updated.
- Commit pushed.
