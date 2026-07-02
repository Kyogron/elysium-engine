export function createLogger(scope: string) {
  return {
    info(message: string) { console.log(`[INFO] [${scope}] ${message}`); },
    warn(message: string) { console.warn(`[WARN] [${scope}] ${message}`); },
    error(message: string) { console.error(`[ERROR] [${scope}] ${message}`); }
  };
}
