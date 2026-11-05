import { randomUUID } from 'node:crypto';
import { readFile } from 'node:fs/promises';
import { resolve } from 'node:path';
import { fileURLToPath } from 'node:url';
import { serve } from '@hono/node-server';
import { createMockServer } from '@scalar/mock-server';
import YAML from 'yaml';

// Mock de desarrollo basado en el contrato. No implementa el backend académico.
export async function createContractMock() {
  const documentPath = resolve('api/openapi.yaml');
  const document = YAML.parse(await readFile(documentPath, 'utf8'));
  const app = await createMockServer({
    document,
    origin: documentPath,
    logger: false,
  });
  return async (request) => {
    const response = await app.fetch(request);
    // El contrato exige un identificador opaco en cada respuesta del mock.
    const headers = new Headers(response.headers);
    if (!headers.get('x-trace-id')) headers.set('X-Trace-Id', randomUUID());
    return new Response(response.body, {
      status: response.status,
      statusText: response.statusText,
      headers,
    });
  };
}

if (process.argv[1] === fileURLToPath(import.meta.url)) {
  const fetch = await createContractMock();
  const server = serve({ fetch, hostname: '127.0.0.1', port: 4010 }, () => {
    console.log('Mock OpenAPI disponible en http://127.0.0.1:4010');
  });
  process.once('SIGTERM', () => server.close());
  process.once('SIGINT', () => server.close());
}
