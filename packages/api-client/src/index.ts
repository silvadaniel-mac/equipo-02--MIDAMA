import createClient from 'openapi-fetch';
import type { paths } from './schema';
export type { paths, components, operations } from './schema';
/** Transporte tipado por el contrato generado. El token se obtiene fuera del SDK. */
export function createAulaVivaClient(baseUrl: string, token: string) {
  return createClient<paths>({ baseUrl, headers: { Authorization: `Bearer ${token}` } });
}
