# Elysium Engine

Base profissional para o desenvolvimento do MOBA Elysium Clash.

## Stack inicial

- Server: Node.js + TypeScript
- Client inicial: HTML/Canvas/WebSocket
- Banco: PostgreSQL ou MySQL/MariaDB via adapters futuros
- Arquitetura: servidor autoritativo + ECS + dados por JSON

## Estrutura

```txt
elysium-engine/
├─ server/      Servidor autoritativo, auth, matchmaking, partidas
├─ client/      Cliente web protótipo
├─ shared/      Tipos e contratos compartilhados
├─ database/    Migrations e seeds
├─ docs/        Documentação técnica
├─ tools/       Scripts auxiliares
└─ assets/      Assets placeholder e futuros recursos
```

## Primeiros comandos

```bash
cd server
npm install
cp .env.example .env
npm run dev
```

Depois abra:

```txt
http://localhost:8080
```

## Roadmap imediato

- 0.1: Estrutura base da engine
- 0.2: Auth real + repositories
- 0.3: Matchmaking + accept match
- 0.4: Champion select
- 0.5: Match server autoritativo com ECS
```
