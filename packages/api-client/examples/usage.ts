import { createAulaVivaClient } from '../src/index';
export async function demo(token: string) {
  const api = createAulaVivaClient('http://127.0.0.1:4010', token);
  const { data, error } = await api.POST('/api/v1/schools/{schoolId}/courses/{courseId}/content', {
    params: { path: { schoolId: 'sch_01', courseId: 'crs_01' },
      header: { 'Idempotency-Key': crypto.randomUUID() } },
    body: { title: 'Guía de álgebra', fileUrl: 'https://example.org/algebra.pdf' }
  });
  if (error) throw new Error(error.detail);
  return data;
}
