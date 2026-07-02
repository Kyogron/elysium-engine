# EntityRegistry

O EntityRegistry é o catálogo central de tipos de entidades disponíveis no cliente Godot.

## Objetivo

Separar a lógica do mundo da forma como os modelos são carregados.

Em vez de o cliente criar uma torre ou campeão manualmente, ele consulta o registry:

```json
{
  "champion_placeholder": {
    "kind": "champion",
    "model": "res://assets/entities/champion_placeholder.tscn",
    "scale": 1.0
  }
}
```

## Responsabilidades

- Carregar `entities.json`.
- Validar tipos de entidade.
- Fornecer caminho do modelo.
- Fornecer metadados como `kind`, `scale` e `displayName`.
- Preparar a base para o EntityFactory.

## Próximo passo

O EntityFactory usará o EntityRegistry e o ResourceManager para criar entidades no mundo automaticamente.
