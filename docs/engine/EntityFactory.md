# EntityFactory

A `EntityFactory` instancia entidades do mundo a partir do `EntityRegistry`.

## Responsabilidades

- Receber uma chave de entidade, como `champion_placeholder` ou `tower_blue`.
- Consultar a definição no `EntityRegistry`.
- Carregar a cena usando `ResourceManager`.
- Instanciar um `Node3D`.
- Aplicar metadados, escala e nome.

## Regra importante

O jogo não deve instanciar entidades diretamente com `preload()` espalhado pelo código. A criação passa pela `EntityFactory`.
