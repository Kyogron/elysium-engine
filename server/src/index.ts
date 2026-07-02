import { WebSocketGateway } from "./network/WebSocketGateway.js";
import { SnapshotSystem } from "./world/SnapshotSystem.js";
import { WorldState } from "./world/WorldState.js";
import { log } from "./utils/logger.js";

const PORT = Number(process.env.PORT ?? 8080);
const SNAPSHOT_RATE_MS = 100;

const world = new WorldState();
const gateway = new WebSocketGateway(PORT, world);
const snapshotSystem = new SnapshotSystem(world, gateway, SNAPSHOT_RATE_MS);

gateway.start();
snapshotSystem.start();

log(`Server listening on ws://localhost:${PORT}`);
log(`Snapshot rate: ${SNAPSHOT_RATE_MS}ms`);
