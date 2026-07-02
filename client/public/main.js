const canvas = document.getElementById('game');
const ctx = canvas.getContext('2d');
const log = document.getElementById('log');
let socket;
let entities = [];
let playerId = null;

function write(message) { log.textContent = `${message}\n` + log.textContent; }

function draw() {
  ctx.clearRect(0, 0, canvas.width, canvas.height);
  ctx.fillStyle = '#263552';
  ctx.fillRect(0, 300, canvas.width, 40);
  for (const entity of entities) {
    const t = entity.components.transform;
    const f = entity.components.faction;
    if (!t) continue;
    ctx.fillStyle = f?.team === 'red' ? '#d05252' : '#4c8dff';
    ctx.beginPath();
    ctx.arc(t.position.x, t.position.y, entity.id === playerId ? 14 : 10, 0, Math.PI * 2);
    ctx.fill();
    ctx.fillStyle = '#fff';
    ctx.fillText(entity.kind, t.position.x + 16, t.position.y + 4);
  }
  requestAnimationFrame(draw);
}

document.getElementById('connect').onclick = () => {
  const room = document.getElementById('room').value || 'default';
  socket = new WebSocket(`ws://${location.host}?room=${encodeURIComponent(room)}`);
  socket.onopen = () => write('Conectado. Clique no mapa para mover.');
  socket.onmessage = (event) => {
    const message = JSON.parse(event.data);
    if (message.type === 'welcome') { playerId = message.playerId; write(`Entrou na sala ${message.roomId}`); }
    if (message.type === 'state') entities = message.entities;
    if (message.type === 'error') write(message.message);
  };
};

canvas.onclick = (event) => {
  if (!socket || socket.readyState !== WebSocket.OPEN) return;
  const rect = canvas.getBoundingClientRect();
  const position = {
    x: (event.clientX - rect.left) * (canvas.width / rect.width),
    y: (event.clientY - rect.top) * (canvas.height / rect.height)
  };
  socket.send(JSON.stringify({ type: 'move', position }));
};

draw();
