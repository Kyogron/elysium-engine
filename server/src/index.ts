import express from 'express';
import { WebSocketServer } from 'ws';
import { loadConfig } from './config/config.js';
import { createLogger } from './utils/logger.js';
import { RoomManager } from './rooms/RoomManager.js';

const config = loadConfig();
const log = createLogger('server');
const app = express();
const rooms = new RoomManager();

app.use(express.json());
app.use(express.static('../client/public'));

app.get('/api/health', (_req, res) => {
  res.json({ ok: true, name: 'Elysium Engine', version: '0.1.0', rooms: rooms.list().length });
});

app.get('/api/rooms', (_req, res) => {
  res.json({ rooms: rooms.list() });
});

app.post('/api/rooms', (req, res) => {
  const name = String(req.body?.name || `room-${Date.now()}`);
  const room = rooms.create(name);
  res.json({ room });
});

const server = app.listen(config.port, config.host, () => {
  log.info(`listening on http://${config.host}:${config.port}`);
});

const wss = new WebSocketServer({ server });

wss.on('connection', (socket, req) => {
  const url = new URL(req.url || '/', `http://${req.headers.host}`);
  const roomId = url.searchParams.get('room') || 'default';
  const room = rooms.getOrCreate(roomId);
  room.connect(socket);
});
