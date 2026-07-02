export type Vector3 = {
  x: number;
  y: number;
  z: number;
};

export type Health = {
  current: number;
  max: number;
};

export type WorldEntitySnapshot = {
  id: string;
  type: string;
  faction?: string;
  position: Vector3;
  rotation: Vector3;
  health: Health;
};

export type ServerHelloMessage = {
  type: "server.hello";
  payload: {
      name: string;
      version: string;
      snapshotRateMs: number;
    };
};

export type WorldSnapshotMessage = {
  type: "world.snapshot";
  payload: {
    serverTime: number;
    entities: WorldEntitySnapshot[];
  };
};

export type PlayerMoveMessage = {
  type: "player.move";
  payload: {
    target: Vector3;
  };
};

export type ClientMessage = PlayerMoveMessage | { type: string; payload?: unknown };
export type ServerMessage = ServerHelloMessage | WorldSnapshotMessage;
