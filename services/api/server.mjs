import http from 'node:http';
import { fileURLToPath } from 'node:url';

// Base de despliegue S07. Los casos de negocio de OpenAPI aún no están implementados.
export function createServer({ labLoad = false } = {}) {
  let ready = true;
  const server = http.createServer((req, res) => {
    const path = new URL(req.url, 'http://localhost').pathname;
    res.setHeader('Content-Type', 'application/json; charset=utf-8');
    res.setHeader('Cache-Control', 'no-store');
    res.setHeader('X-Content-Type-Options', 'nosniff');
    const send = (code, body) => {
      res.writeHead(code);
      res.end(JSON.stringify(body));
    };
    if (req.method !== 'GET') return send(405, { error: 'method_not_allowed' });
    if (path === '/healthz') return send(200, { status: 'alive' });
    if (path === '/readyz')
      return send(ready ? 200 : 503, { status: ready ? 'ready' : 'draining' });
    if (path === '/')
      return send(200, {
        service: 'aulaviva-api',
        stage: 'S08',
        release: process.env.RELEASE_SHA || 'local',
        businessApi: 'not_implemented',
      });
    if (path === '/lab/work' && labLoad) {
      // Carga acotada, solo para laboratorio. No habilitar en producción.
      const end = performance.now() + 40;
      while (performance.now() < end) Math.sqrt(Math.random());
      return send(200, { status: 'lab_work_completed' });
    }
    if (path.startsWith('/api/'))
      return send(501, {
        error: 'not_implemented',
        contract: 'api/openapi.yaml',
      });
    return send(404, { error: 'not_found' });
  });
  server.requestTimeout = 5000;
  server.headersTimeout = 5000;
  return {
    server,
    drain: () => {
      ready = false;
    },
  };
}

if (process.argv[1] === fileURLToPath(import.meta.url)) {
  const { server, drain } = createServer({
    labLoad: process.env.ENABLE_LAB_LOAD === 'true',
  });
  const port = Number(process.env.PORT || 8080);
  if (!Number.isInteger(port) || port < 1 || port > 65535)
    throw new Error('PORT inválido');
  server.listen(port, '0.0.0.0', () =>
    console.log(JSON.stringify({ event: 'listening', port })),
  );
  process.once('SIGTERM', () => {
    drain();
    console.log(JSON.stringify({ event: 'shutdown' }));
    server.close(() => process.exit(0));
    setTimeout(() => process.exit(1), 10000).unref();
  });
}
