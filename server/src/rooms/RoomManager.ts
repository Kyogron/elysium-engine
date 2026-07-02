import type { WebSocket } from 'ws';
import { GameRoom } from './GameRoom.js';

export class RoomManager {
  private rooms = new Map<string, GameRoom>();

  create(id: string): { id: string; players: number } {
    const room = this.getOrCreate(id);
    return room.summary();
  }

  getOrCreate(id: string): GameRoom {
    let room = this.rooms.get(id);
    if (!room) {
      room = new GameRoom(id);
      this.rooms.set(id, room);
    }
    return room;
  }

  list() {
    return [...this.rooms.values()].map((room) => room.summary());
  }
}
