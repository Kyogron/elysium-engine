# Instalação — Sprint 3.1

1. Extraia este pacote fora do repositório.
2. Copie as pastas `client/` e `docs/` para a raiz do repositório.
3. Edite `client/godot/project.godot` e adicione em `[autoload]`:

```ini
ResourceManager="*res://core/resources/ResourceManager.gd"
```

Exemplo:

```ini
[autoload]
NetworkManager="*res://autoload/NetworkManager.gd"
ResourceManager="*res://core/resources/ResourceManager.gd"
```

4. Abra o projeto no Godot e execute.
