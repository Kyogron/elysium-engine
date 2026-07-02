import type { Entity, EntityId } from './types.js';

export class EntityStore {
  private entities = new Map<EntityId, Entity>();

  create(entity: Entity): Entity {
    this.entities.set(entity.id, entity);
    return entity;
  }

  get(id: EntityId): Entity | undefined {
    return this.entities.get(id);
  }

  remove(id: EntityId): boolean {
    return this.entities.delete(id);
  }

  all(): Entity[] {
    return [...this.entities.values()];
  }
}
