export type EntityId = string;

export type Vector2 = { x: number; y: number };

export type Entity = {
  id: EntityId;
  kind: 'champion' | 'minion' | 'tower' | 'base' | 'projectile';
  components: Record<string, unknown>;
};

export type Transform = { position: Vector2; rotation: number };
export type Health = { current: number; max: number; dead: boolean };
export type Faction = { team: 'blue' | 'red' | 'neutral' };
export type Movement = { speed: number; target?: Vector2 };
export type Combat = { attackDamage: number; range: number; attackSpeed: number; lastAttackAt: number };
