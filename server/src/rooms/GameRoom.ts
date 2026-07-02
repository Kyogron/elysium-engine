import type { WebSocket } from 'ws';
import { randomUUID } from 'crypto';
import { EntityStore } from '../ecs/EntityStore.js';

export class GameRoom {
  private sockets = new Map<string, WebSocket>();
  private entities = new EntityStore();

  constructor(public readonly id: string) {}

  connect(socket: WebSocket) {
    const playerId = randomUUID();
    this.sockets.set(playerId, socket);
    this.entities.create({
      id: playerId,
      kind: 'champion',
      components: {
        transform: { position: { x: 200, y: 200 }, rotation: 0 },
        health: { current: 620, max: 620, dead: false },
        faction: { team: this.sockets.size % 2 === 0 ? 'red' : 'blue' },
        movement: { speed: 335 }
      }
    });

    socket.send(JSON.stringify({ type: 'welcome', playerId, roomId: this.id }));
    this.broadcastState();

    socket.on('message', (raw) => {
      try {
        const message = JSON.parse(String(raw));
        if (message.type === 'move') {
          const entity = this.entities.get(playerId);
          if (entity) {
            entity.components.transform = { position: message.position, rotation: 0 };
            this.broadcastState();
          }
        }
      } catch {
        socket.send(JSON.stringify({ type: 'error', message: 'Invalid message' }));
      }
    });

    socket.on('close', () => {
      this.sockets.delete(playerId);
      this.entities.remove(playerId);
      this.broadcastState();
    });
  }

  summary() {
    return { id: this.id, players: this.sockets.size };
  }

  private broadcastState() {
    const payload = JSON.stringify({ type: 'state', entities: this.entities.all() });
    for (const socket of this.sockets.values()) {
      socket.send(payload);
    }
  }
}
