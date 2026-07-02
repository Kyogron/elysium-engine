# Arquitetura da Elysium Engine

A engine será construída com servidor autoritativo. O cliente envia intenções, e o servidor calcula o estado real da partida.

## Estados principais

1. Auth
2. Lobby
3. Matchmaking
4. Accept Match
5. Champion Select
6. Loading
7. In Game
8. Finished

## Núcleos técnicos

- ECS para entidades de jogo
- WebSocket para tempo real
- REST para lobby/auth/configuração
- Dados de campeões, itens e habilidades por JSON
- Banco com repositories e migrations
