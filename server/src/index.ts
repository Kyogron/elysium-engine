import { WebSocketServer } from "ws";

const PORT = Number(process.env.PORT ?? 8080);

const wss = new WebSocketServer({ port: PORT });

wss.on("connection", (socket) => {
  socket.send(JSON.stringify({
    type: "server.hello",
    payload: {
      name: "Elysium Engine",
      version: "0.1.0"
    }
  }));

  socket.on("message", (data) => {
    socket.send(JSON.stringify({
      type: "server.echo",
      payload: data.toString()
    }));
  });
});

console.log(`[Elysium] Server listening on ws://localhost:${PORT}`);