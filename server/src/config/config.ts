import 'dotenv/config';

export type ServerConfig = {
  host: string;
  port: number;
  databaseType: 'json' | 'postgres' | 'mysql';
  serverSecret: string;
  tickRate: number;
};

export function loadConfig(): ServerConfig {
  return {
    host: process.env.HOST || '0.0.0.0',
    port: Number(process.env.PORT || 8080),
    databaseType: (process.env.DATABASE_TYPE || 'json') as ServerConfig['databaseType'],
    serverSecret: process.env.SERVER_SECRET || 'dev-secret',
    tickRate: Number(process.env.TICK_RATE || 20)
  };
}
