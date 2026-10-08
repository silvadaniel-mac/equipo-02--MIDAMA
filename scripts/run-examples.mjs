import { readdir, readFile } from 'node:fs/promises';
import assert from 'node:assert/strict';
import { randomUUID } from 'node:crypto';
const base = process.env.API_BASE_URL || 'http://127.0.0.1:4010';
const token = process.env.API_TOKEN || 'mock-only-token';
for (const name of (await readdir('api/examples')).filter(n => n.endsWith('.json')).sort()) {
  const e = JSON.parse(await readFile(`api/examples/${name}`, 'utf8'));
  const headers = { Authorization: `Bearer ${token}`, Accept: 'application/json' };
  if (e.body) { headers['Content-Type'] = 'application/json'; headers['Idempotency-Key'] = randomUUID(); }
  const res = await fetch(new URL(e.path, base), {
    method: e.method, headers, body: e.body ? JSON.stringify(e.body) : undefined,
    signal: AbortSignal.timeout(10000)
  });
  assert.equal(res.status, e.expectedStatus, `${name}: status inesperado`);
  const data = await res.json();
  for (const field of e.expectedFields) assert.ok(field in data, `${name}: falta ${field}`);
  assert.ok(res.headers.get('x-trace-id'), `${name}: falta trazabilidad`);
  console.log(`PASS ${name} (${res.status})`);
}
