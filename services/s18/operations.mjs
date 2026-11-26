import { mkdtemp,rm,copyFile,writeFile,mkdir } from 'node:fs/promises';
import { tmpdir } from 'node:os';
import { join } from 'node:path';
import { randomBytes,randomUUID } from 'node:crypto';
import assert from 'node:assert/strict';
import { createAcademicServer,issueToken } from './server.mjs';
const outdir=new URL('../../docs/evidencias/s18/',import.meta.url);await mkdir(outdir,{recursive:true});
const dir=await mkdtemp(join(tmpdir(),'s18-dr-')),dbPath=join(dir,'lab.sqlite'),snapshot=join(dir,'snapshot.sqlite'),secret=randomBytes(32).toString('hex');
const base='/api/v1/schools/sch_01/courses/crs_01/content';let app;
async function start(){app=createAcademicServer({dbPath,secret});await new Promise(r=>app.server.listen(0,'127.0.0.1',r));return 'http://127.0.0.1:'+app.server.address().port;}
async function close(){await app.close();app=null;}
const call=(origin,path,who='teacher',body)=>fetch(origin+path,{method:body?'POST':'GET',headers:{authorization:'Bearer '+issueToken(secret,who),'content-type':'application/json','idempotency-key':randomUUID()},...(body?{body:JSON.stringify(body)}:{})});
try{
 let origin=await start();let r=await call(origin,base,'teacher',{title:'Álgebra',description:'Ecuaciones: aislar la incógnita.',fileUrl:'https://example.org/1.pdf'});assert.equal(r.status,201);const preserved=await r.json();
 const samples=[];const windowStart=Date.now();for(let i=0;i<100;i++){const t=performance.now();const probe=await fetch(origin+'/readyz');samples.push({status:probe.status,ms:Math.round((performance.now()-t)*100)/100});await probe.arrayBuffer();await new Promise(r=>setTimeout(r,20));}const windowEnd=Date.now();
 await close();await copyFile(dbPath,snapshot);const snapshotAt=Date.now();
 origin=await start();r=await call(origin,base,'teacher',{title:'Cambio posterior al respaldo',description:'Contenido de prueba.',fileUrl:'https://example.org/2.pdf'});assert.equal(r.status,201);const lost=await r.json();await close();
 const incidentAt=Date.now(),t=performance.now();await rm(dbPath);await copyFile(snapshot,dbPath);origin=await start();r=await call(origin,base,'student');const restored=await r.json();assert.equal(r.status,200);assert.deepEqual(restored.items,[preserved]);assert.ok(!restored.items.some(x=>x.id===lost.id));assert.equal((await call(origin,base,'outsider')).status,404);assert.equal((await fetch(origin+'/readyz')).status,200);const rtoMs=performance.now()-t;
 const lat=samples.map(x=>x.ms).sort((a,b)=>a-b);const good=samples.filter(x=>x.status===200&&x.ms<=2000).length;
 const report={scope:'laboratorio SQLite; no AWS ni SLO de producción',commit:process.env.GITHUB_SHA||'local',date:new Date().toISOString(),slo:{target:0.995,windowStart:new Date(windowStart).toISOString(),windowEnd:new Date(windowEnd).toISOString(),samples:samples.length,good,ratio:good/samples.length,p95Ms:lat[Math.ceil(lat.length*.95)-1],samplesDetail:samples},recovery:{scenario:'eliminación deliberada de copia temporal y restauración desde snapshot consistente',rtoMs:Math.round(rtoMs*100)/100,rpoMs:incidentAt-snapshotAt,recordsPreserved:1,recordsLostSinceBackup:1,crossTenantStatus:404,readinessStatus:200,pass:true},limitations:['Muestra breve; no ventana de 30 días.','RPO es antigüedad del snapshot; una escritura posterior se pierde deliberadamente.','No valida RDS, alta disponibilidad ni carga real.']};
 await writeFile(new URL('operations-results.json',outdir),JSON.stringify(report,null,2)+'\n');console.log(JSON.stringify({...report,slo:{...report.slo,samplesDetail:undefined}},null,2));assert.equal(good,100);
}finally{if(app)await close();await rm(dir,{recursive:true,force:true});}
