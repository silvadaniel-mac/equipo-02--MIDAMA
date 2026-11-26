import assert from 'node:assert/strict';
import {randomUUID} from 'node:crypto';
import {issueToken} from './server.mjs';
const secret=process.env.S18_SECRET;
if(!secret)throw Error('S18_SECRET requerida para staging');
const origin='http://127.0.0.1:18081',base='/api/v1/schools/sch_01/courses/crs_01';
async function call(path,who,body,expected){
 const r=await fetch(origin+path,{method:body?'POST':'GET',headers:{...(who?{authorization:'Bearer '+issueToken(secret,who)}:{}),'content-type':'application/json','idempotency-key':randomUUID()},...(body?{body:JSON.stringify(body)}:{})});
 const data=await r.json();assert.equal(r.status,expected);console.log(JSON.stringify({path,status:r.status,body:data}));return data;
}
const release=await call('/',null,null,200);
assert.equal(release.release,process.env.GITHUB_SHA||release.release);
await call('/readyz',null,null,200);
const c=await call(base+'/content','teacher',{title:'Álgebra de prueba',description:'Una ecuación de primer grado se resuelve aislando la incógnita.',fileUrl:'https://example.org/algebra.pdf'},201);
const list=await call(base+'/content','student',null,200);
assert.ok(list.items.some(x=>x.id===c.id));
const answer=await call(base+'/tutor-queries','student',{question:'ecuación de primer grado'},201);
assert.deepEqual(answer.contentIds,[c.id]);
await call(base+'/content','outsider',null,404);
const no=await call(base+'/tutor-queries','student',{question:'vulcanología'},201);assert.deepEqual(no.contentIds,[]);
console.log('STAGING ACADEMICO POR DIGEST: flujo completo aprobado');
