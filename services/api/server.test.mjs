import test from 'node:test';
import assert from 'node:assert/strict';
import { once } from 'node:events';
import { createServer } from './server.mjs';

async function fixture(t, options) {
  const app = createServer(options);
  app.server.listen(0, '127.0.0.1');
  await once(app.server, 'listening');
  t.after(() => new Promise(resolve => app.server.close(resolve)));
  return { ...app, url: `http://127.0.0.1:${app.server.address().port}` };
}
test('probes separan proceso vivo de disponibilidad durante cierre', async t => {
  const app = await fixture(t);
  assert.equal((await fetch(`${app.url}/readyz`)).status, 200);
  app.drain();
  assert.equal((await fetch(`${app.url}/readyz`)).status, 503);
  assert.equal((await fetch(`${app.url}/healthz`)).status, 200);
});
test('la base de despliegue no simula casos de negocio implementados', async t => {
  const { url } = await fixture(t);
  const res = await fetch(`${url}/api/v1/contents`);
  assert.equal(res.status, 501);
  assert.equal((await res.json()).error, 'not_implemented');
  assert.equal((await fetch(`${url}/`, { method: 'POST' })).status, 405);
  assert.equal((await fetch(`${url}/missing`)).status, 404);
});
test('la carga sintética está deshabilitada por defecto', async t => {
  const { url } = await fixture(t);
  assert.equal((await fetch(`${url}/lab/work`)).status, 404);
});
test('la carga sintética se puede activar expresamente para el laboratorio', async t => {
  const { url } = await fixture(t, { labLoad: true });
  const res = await fetch(`${url}/lab/work`);
  assert.equal(res.status, 200);
  assert.equal((await res.json()).status, 'lab_work_completed');
});
