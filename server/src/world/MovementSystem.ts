import type { Vector3 } from "../protocol/messages.js";
import type { WorldEntity } from "./WorldState.js";

const MAP_BOUNDS = {
  minX: -24,
  maxX: 24,
  minZ: -16,
  maxZ: 16,
};

export class MovementSystem {
  static clampTarget(target: Vector3): Vector3 {
    return {
      x: Math.max(MAP_BOUNDS.minX, Math.min(MAP_BOUNDS.maxX, target.x)),
      y: 0,
      z: Math.max(MAP_BOUNDS.minZ, Math.min(MAP_BOUNDS.maxZ, target.z)),
    };
  }

  static moveTowardsTarget(entity: WorldEntity, deltaSeconds: number): void {
    if (!entity.moveTarget || entity.speed <= 0) {
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
