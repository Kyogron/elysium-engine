import { WebSocket, WebSocketServer } from "ws";
import type { ClientMessage, ServerMessage } from "../protocol/messages.js";
import type { WorldState } from "../world/WorldState.js";
import { warn } from "../utils/logger.js";

export class WebSocketGateway {
  private server: WebSocketServer | undefined;

  constructor(
    private readonly port: number,
    private readonly world: WorldState,
    private readonly snapshotRateMs: number,
  ) {}

  start(): void {
    this.server = new WebSocketServer({ port: this.port });
    this.server.on("connection", (socket) => this.handleConnection(socket));
  }

  broadcast(message: ServerMessage): void {
    if (!this.server) {
      return;
    }

    const encoded = JSON.stringify(message);
    for (const client of this.server.clients) {
      if (client.readyState === WebSocket.OPEN) {
        client.send(encoded);
      }
    }
  }

  private handleConnection(socket: WebSocket): void {
    socket.send(JSON.stringify({
      type: "server.hello",
      payload: {
        name: "Elysium Engine",
        version: "0.3.0",
        snapshotRateMs: this.snapshotRateMs,
      },
    }));

    socket.on("message", (data) => {
      this.handleMessage(data.toString());
    });
  }

  private handleMessage(raw: string): void {
    let message: ClientMessage;
    try {
      message = JSON.parse(raw) as ClientMessage;
    } catch {
      warn("Ignored invalid JSON client message.");
      return;
    }

    if (message.type !== "player.move") {
      return;
    }

    const payload = typeof message.payload === "object" && message.payload !== null
      ? message.payload as { target?: unknown }
      : {};
    const target = payload.target as { x?: unknown; y?: unknown; z?: unknown } | undefined;
    const x = target?.x;
    const y = target?.y;
    const z = target?.z;
    if (
      typeof x !== "number" || !Number.isFinite(x) ||
      typeof y !== "number" || !Number.isFinite(y) ||
      typeof z !== "number" || !Number.isFinite(z)
    ) {
      warn("Ignored invalid player.move payload.");
      return;
    }

    this.world.setPlayerMoveTarget("player_1", {
      x,
      y,
      z,
    });
  }
}
