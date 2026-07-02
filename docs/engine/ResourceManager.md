# ResourceManager

O `ResourceManager` é o carregador centralizado de recursos do cliente Godot da Elysium Engine.

## Objetivo

Evitar `preload()` espalhado pelo projeto e preparar a engine para carregar modelos, cenas, texturas, materiais, UI e assets futuros por caminho/registro.

## Responsabilidades

- Carregar recursos usando `ResourceLoader`.
- Manter cache em memória.
- Evitar carregamento duplicado do mesmo recurso.
- Instanciar cenas de forma padronizada.
- Servir como base para `EntityFactory` e `Asset Pipeline`.

## API

### `load_resource(path: String) -> Resource`

Carrega um recurso por caminho e salva no cache.

### `load_scene(path: String) -> PackedScene`

Carrega uma cena e valida se o recurso é `PackedScene`.

### `instantiate_scene(path: String) -> Node`

Instancia uma cena usando o cache do `ResourceManager`.

### `has_cached(path: String) -> bool`

Verifica se o recurso já está em cache.

### `unload_resource(path: String) -> void`

Remove um recurso específico do cache.

### `clear_cache() -> void`

Limpa todo o cache.

### `cache_size() -> int`

Retorna a quantidade de recursos atualmente em cache.

## Próximo passo

O próximo sistema será o `EntityRegistry`, responsável por mapear tipos de entidade como `tower_blue`, `loogon` e `minion_melee` para caminhos de assets.
