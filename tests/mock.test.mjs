import { test } from 'node:test';
import assert from 'node:assert/strict';
import { randomUUID } from 'node:crypto';
import { readFile } from 'node:fs/promises';
import { createContractMock } from '../scripts/mock-api.mjs';

const respond = await createContractMock();
const base = 'http://127.0.0.1:4010';
const path = '/api/v1/schools/sch_01/courses/crs_01/tutor-queries';

for (const name of [
  '01-list-content',
  '02-create-content',
  '03-create-grade',
  '04-tutor-query',
]) {
  test(`Mock OpenAPI conserva el ejemplo ${name}`, async () => {
    const example = JSON.parse(
      await readFile(`api/examples/${name}.json`, 'utf8'),
    );
    const headers = {
      Authorization: 'Bearer mock-only-token',
      Accept: 'application/json',
    };
    if (example.body) {
      headers['Content-Type'] = 'application/json';
      headers['Idempotency-Key'] = randomUUID();
    }
    const response = await respond(
      new Request(new URL(example.path, base), {
        method: example.method,
        headers,
        body: example.body ? JSON.stringify(example.body) : undefined,
      }),
    );
    assert.equal(response.status, example.expectedStatus);
    assert.ok(response.headers.get('x-trace-id'));
    const body = await response.json();
    for (const field of example.expectedFields) assert.ok(field in body);
  });
}

test('Mock rechaza llamadas sin autenticación', async () => {
  const response = await respond(
    new Request(`${base}/api/v1/schools/sch_01/courses/crs_01/content`),
  );
  assert.equal(response.status, 401);
});

test('Mock rechaza cuerpo que incumple el esquema', async () => {
  const response = await respond(
    new Request(base + path, {
      method: 'POST',
      headers: {
        Authorization: 'Bearer mock-only-token',
        'Content-Type': 'application/json',
        'Idempotency-Key': randomUUID(),
      },
      body: '{}',
    }),
  );
  assert.equal(response.status, 422);
  assert.ok(
    (await response.json()).violations.some((v) => v.location === 'body'),
  );
});

test('Mock exige el encabezado de idempotencia', async () => {
  const response = await respond(
    new Request(base + path, {
      method: 'POST',
      headers: {
        Authorization: 'Bearer mock-only-token',
        'Content-Type': 'application/json',
      },
      body: JSON.stringify({ question: '¿Qué es una ecuación?' }),
    }),
  );
  assert.equal(response.status, 422);
  assert.ok(
    (await response.json()).violations.some((v) => v.location === 'header'),
  );
});
