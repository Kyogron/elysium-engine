import type { Vector3, WorldEntitySnapshot } from "../protocol/messages.js";
import { MovementSystem } from "./MovementSystem.js";

export type WorldEntity = WorldEntitySnapshot & {
  moveTarget?: Vector3;
  speed: number;
};

const PLAYER_SPEED_UNITS_PER_SECOND = 5;

export class WorldState {
  private readonly entities = new Map<string, WorldEntity>();
  private lastUpdate = Date.now();

  constructor() {
    this.entities.set("player_1", {
      id: "player_1",
      type: "champion_placeholder",
      faction: "blue",
      position: { x: -6, y: 0, z: 0 },
      rotation: { x: 0, y: 0, z: 0 },
      health: { current: 100, max: 100 },
      speed: PLAYER_SPEED_UNITS_PER_SECOND,
    });

    this.entities.set("minion_1", {
      id: "minion_1",
      type: "minion_placeholder",
      faction: "blue",
      position: { x: 2, y: 0, z: -2 },
      rotation: { x: 0, y: 0, z: 0 },
      health: { current: 35, max: 35 },
      speed: 0,
    });

    this.entities.set("tower_1", {
      id: "tower_1",
      type: "tower_placeholder",
      faction: "red",
      position: { x: 12, y: 0, z: 0 },
      rotation: { x: 0, y: 0, z: 0 },
      health: { current: 500, max: 500 },
      speed: 0,
    });
  }

  update(): void {
    const now = Date.now();
    const deltaSeconds = (now - this.lastUpdate) / 1000;
    this.lastUpdate = now;

    for (const entity of this.entities.values()) {
      MovementSystem.moveTowardsTarget(entity, deltaSeconds);
    }
  }

  setPlayerMoveTarget(playerId: string, target: Vector3): void {
    const entity = this.entities.get(playerId);
    if (!entity) {
      return;
    }

    entity.moveTarget = MovementSystem.clampTarget(target);
  }

  createSnapshot(): WorldEntitySnapshot[] {
    this.update();
    return [...this.entities.values()].map((entity) => ({
      id: entity.id,
      type: entity.type,
      faction: entity.faction,
      position: entity.position,
      rotation: entity.rotation,
      health: entity.health,
    }));
  }
}
