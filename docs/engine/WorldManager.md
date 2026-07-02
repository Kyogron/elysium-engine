# WorldManager

O `WorldManager` é responsável por manter a representação visual do mundo sincronizada com os snapshots do servidor.

## Responsabilidades

- Criar entidades usando `EntityFactory`.
- Atualizar posição, rotação e escala de entidades existentes.
- Remover entidades que não aparecem mais no snapshot.
- Manter o mapa `entityId -> Node3D`.

## Importante

O `WorldManager` não decide regras de jogo. Ele apenas representa visualmente o estado autoritativo recebido do servidor.

## Snapshot esperado

```json
{
  "id": "player-1",
  "type": "champion_placeholder",
  "position": [0, 0, 0],
  "rotation_y": 0,
  "scale": 1
}
```

## Batch esperado

```json
[
  {
    "id": "player-1",
    "type": "champion_placeholder",
    "position": [0, 0, 0]
  },
  {
    "id": "tower-blue-1",
    "type": "tower_blue",
    "position": [10, 0, 0]
  }
]
```
