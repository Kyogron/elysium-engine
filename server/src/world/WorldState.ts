import type { Vector3, WorldEntitySnapshot } from "../protocol/messages.js";

type WorldEntity = WorldEntitySnapshot & {
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
      position: { x: -6, y: 0, z: 0 },
      rotation: { x: 0, y: 0, z: 0 },
      health: { current: 100, max: 100 },
      speed: PLAYER_SPEED_UNITS_PER_SECOND,
    });

    this.entities.set("minion_1", {
      id: "minion_1",
      type: "minion_placeholder",
      position: { x: 2, y: 0, z: -2 },
      rotation: { x: 0, y: 0, z: 0 },
      health: { current: 35, max: 35 },
      speed: 0,
    });

    this.entities.set("tower_1", {
      id: "tower_1",
      type: "tower_placeholder",
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
      if (!entity.moveTarget || entity.speed <= 0) {
        continue;
      }

      this.moveTowardsTarget(entity, deltaSeconds);
    }
  }

  setPlayerMoveTarget(playerId: string, target: Vector3): void {
    const entity = this.entities.get(playerId);
    if (!entity) {
      return;
    }

    entity.moveTarget = { x: target.x, y: 0, z: target.z };
  }

  createSnapshot(): WorldEntitySnapshot[] {
    this.update();
    return [...this.entities.values()].map((entity) => ({
      id: entity.id,
      type: entity.type,
      position: entity.position,
      rotation: entity.rotation,
      health: entity.health,
    }));
  }

  private moveTowardsTarget(entity: WorldEntity, deltaSeconds: number): void {
    if (!entity.moveTarget) {
      return;
    }

    const dx = entity.moveTarget.x - entity.position.x;
    const dz = entity.moveTarget.z - entity.position.z;
    const distance = Math.hypot(dx, dz);

    if (distance < 0.05) {
      entity.position = { ...entity.moveTarget };
      entity.moveTarget = undefined;
      return;
    }

    const step = Math.min(entity.speed * deltaSeconds, distance);
    entity.position = {
      x: entity.position.x + (dx / distance) * step,
      y: 0,
      z: entity.position.z + (dz / distance) * step,
    };
    entity.rotation = {
      x: 0,
      y: Math.atan2(dx, dz),
      z: 0,
    };
  }
}
