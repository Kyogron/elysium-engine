import type { WebSocketGateway } from "../network/WebSocketGateway.js";
import type { WorldSnapshotMessage } from "../protocol/messages.js";
import type { WorldState } from "./WorldState.js";

export class SnapshotSystem {
  private timer: NodeJS.Timeout | undefined;

  constructor(
    private readonly world: WorldState,
    private readonly gateway: WebSocketGateway,
    private readonly snapshotRateMs: number,
  ) {}

  start(): void {
    if (this.timer) {
      return;
    }

    this.timer = setInterval(() => {
      const message: WorldSnapshotMessage = {
        type: "world.snapshot",
        payload: {
          serverTime: Date.now(),
          entities: this.world.createSnapshot(),
        },
      };

      this.gateway.broadcast(message);
    }, this.snapshotRateMs);
  }

  stop(): void {
    if (!this.timer) {
      return;
    }

    clearInterval(this.timer);
    this.timer = undefined;
  }
}
