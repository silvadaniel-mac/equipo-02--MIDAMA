import { test } from 'node:test';
import assert from 'node:assert/strict';
import { readFile, mkdtemp, writeFile, rm } from 'node:fs/promises';
import { tmpdir } from 'node:os';
import { join, resolve } from 'node:path';
import { spawnSync } from 'node:child_process';
import YAML from 'yaml';
const doc = YAML.parse(await readFile('api/openapi.yaml', 'utf8'));
const verbs = new Set(['get','post','put','patch','delete','options','head','trace']);
const operations = Object.values(doc.paths).flatMap(path => Object.entries(path).filter(([v]) => verbs.has(v)));
test('S05 y garantías transversales del contrato', () => {
  assert.equal(doc.openapi, '3.1.0');
  assert.ok(Object.keys(doc.paths).length >= 5);
  assert.ok(operations.length >= 5);
  assert.ok(Object.keys(doc.components.schemas).length >= 3);
  for (const [method, op] of operations) {
    assert.ok(op.summary && op.operationId);
    for (const code of ['400','401','403','404','429']) assert.ok(op.responses[code]);
    if (method === 'post') {
      assert.ok(op.parameters.some(p => p.$ref.endsWith('/IdempotencyKey')));
      assert.ok(op.responses['409']);
      assert.ok(op.responses['201'].headers.Location);
    }
  }
  assert.equal(doc.components.parameters.IdempotencyKey.required, true);
  assert.equal(doc.components.securitySchemes.bearerAuth.scheme, 'bearer');
  for (const response of Object.values(doc.components.responses)) {
    assert.equal(response.content['application/problem+json'].schema.$ref, '#/components/schemas/Problem');
  }
});
async function expectLintFailure(mutate, rule) {
  const copy = structuredClone(doc);
  mutate(copy);
  const dir = await mkdtemp(join(tmpdir(), 'aulaviva-s05-'));
  try {
    const file = join(dir, 'invalid.yaml');
    await writeFile(file, YAML.stringify(copy));
    const result = spawnSync(process.execPath, [resolve('node_modules/@stoplight/spectral-cli/dist/index.js'),
      'lint', file, '--ruleset', resolve('.spectral.yaml'), '--format', 'json'], { encoding: 'utf8' });
    assert.equal(result.status, 1, result.stderr);
    assert.ok(JSON.parse(result.stdout).some(d => d.code === rule && d.severity === 0));
  } finally { await rm(dir, { recursive: true, force: true }); }
}
test('Spectral detecta summary ausente dentro de una operación', async () => {
  await expectLintFailure(d => { delete Object.values(d.paths)[0].get.summary; }, 'operation-summary-required');
});
test('Spectral rechaza rutas con verbos camelCase', async () => {
  await expectLintFailure(d => { d.paths['/createCreditApplication'] = Object.values(d.paths)[0]; }, 'paths-kebab-case');
});
