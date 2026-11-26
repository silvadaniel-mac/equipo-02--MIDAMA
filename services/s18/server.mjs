// Laboratorio académico aislado. Node 24, datos ficticios.
import http from 'node:http';
import { DatabaseSync } from 'node:sqlite';
import { createHmac, timingSafeEqual, randomUUID, createHash } from 'node:crypto';
import { fileURLToPath } from 'node:url';
import { answerTutor } from './tutor.mjs';
const b64=x=>Buffer.from(JSON.stringify(x)).toString('base64url');
const demoUsers={teacher:{sub:'teacher_01',school:'sch_01',course:'crs_01',role:'docente'},student:{sub:'student_01',school:'sch_01',course:'crs_01',role:'estudiante'},outsider:{sub:'student_02',school:'sch_02',course:'crs_01',role:'estudiante'}};
export function issueToken(secret,user,now=Math.floor(Date.now()/1000)) {
  if(!demoUsers[user]) throw Error('Identidad ficticia desconocida');
  const data=b64({alg:'HS256',typ:'JWT'})+'.'+b64({...demoUsers[user],iss:'aulaviva-s18-lab',aud:'aulaviva-api',iat:now,exp:now+3600});
  return data+'.'+createHmac('sha256',secret).update(data).digest('base64url');
}
function auth(header,secret) {
  try {
    const [h,p,s,...rest]=header?.match(/^Bearer ([^ ]+)$/)?.[1]?.split('.')||[];
    if(rest.length||!h||!p||!s)return null;
    const expected=createHmac('sha256',secret).update(h+'.'+p).digest(), actual=Buffer.from(s,'base64url');
    if(actual.length!==expected.length||!timingSafeEqual(expected,actual))return null;
    const meta=JSON.parse(Buffer.from(h,'base64url')), claims=JSON.parse(Buffer.from(p,'base64url'));
    if(meta.alg!=='HS256'||claims.iss!=='aulaviva-s18-lab'||claims.aud!=='aulaviva-api'||!Number.isInteger(claims.exp)||claims.exp<=Date.now()/1000)return null;
    if(!Object.values(demoUsers).some(x=>Object.keys(x).every(k=>x[k]===claims[k])))return null;
    return claims;
  }catch{return null;}
}
export function createAcademicServer({dbPath=':memory:',secret,model=''}={}) {
  if(typeof secret!=='string'||Buffer.byteLength(secret)<32)throw Error('S18_SECRET requiere al menos 32 bytes');
  const db=new DatabaseSync(dbPath);
  db.prepare('PRAGMA foreign_keys=ON').run();
  db.prepare('PRAGMA busy_timeout=3000').run();
  db.prepare('CREATE TABLE IF NOT EXISTS content (school TEXT NOT NULL, course TEXT NOT NULL, id TEXT PRIMARY KEY, title TEXT NOT NULL, description TEXT, fileUrl TEXT NOT NULL, createdAt TEXT NOT NULL)').run();
  db.prepare('CREATE INDEX IF NOT EXISTS content_scope ON content(school,course,id)').run();
  db.prepare('CREATE TABLE IF NOT EXISTS idem (scope TEXT PRIMARY KEY, fingerprint TEXT NOT NULL, body TEXT NOT NULL, location TEXT NOT NULL, expires INTEGER NOT NULL)').run();
  const getContents=(school,course)=>db.prepare('SELECT id,title,description,fileUrl,createdAt FROM content WHERE school=? AND course=? ORDER BY id').all(school,course).map(({description,...row})=>description===null?row:{...row,description});
  const server=http.createServer(async(req,res)=>{
    const trace=randomUUID(); let path='/';
    res.setHeader('X-Trace-Id',trace);res.setHeader('Cache-Control','no-store');res.setHeader('X-Content-Type-Options','nosniff');res.setHeader('Content-Security-Policy',"default-src 'none'; frame-ancestors 'none'; base-uri 'none'; form-action 'none'");res.setHeader('X-Frame-Options','DENY');res.setHeader('Referrer-Policy','no-referrer');res.setHeader('Cross-Origin-Resource-Policy','same-origin');res.setHeader('Permissions-Policy','camera=(), microphone=(), geolocation=()');
    const send=(status,body,location)=>{if(location)res.setHeader('Location',location);res.writeHead(status,{'Content-Type':status>=400?'application/problem+json':'application/json'});res.end(JSON.stringify(body));};
    const fail=(status,title,detail)=>send(status,{type:'about:blank',title,status,detail,instance:path,trace_id:trace});
    try {
      const url=new URL(req.url,'http://localhost');path=url.pathname;
      if(req.method==='GET'&&path==='/healthz')return send(200,{status:'alive'});
      if(req.method==='GET'&&path==='/readyz'){db.prepare('SELECT 1').get();return send(200,{status:'ready'});}
      if(req.method==='GET'&&path==='/')return send(200,{service:'aulaviva-s18',stage:'s18-academic-lab',release:process.env.RELEASE_SHA||'local',tutorMode:model?'ollama-optional':'extractive'});
      const m=path.match(/^\/api\/v1\/schools\/([\w-]+)\/courses\/([\w-]+)\/(content|tutor-queries)$/);
      if(!m)return fail(404,'Not found','Ruta no disponible en el alcance S18.');
      const user=auth(req.headers.authorization,secret);
      if(!user)return fail(401,'Unauthorized','Identidad no válida.');
      const [,school,course,resource]=m;
      if(user.school!==school||user.course!==course)return fail(404,'Not found','Recurso no encontrado.');
      if(req.method==='GET'&&resource==='content') {
        const limit=Number(url.searchParams.get('limit')||20), cursor=url.searchParams.get('cursor');
        if(!Number.isInteger(limit)||limit<1||limit>100)return fail(400,'Bad request','Límite inválido.');
        const all=getContents(school,course);let start=0;
        if(cursor!==null){const pos=all.findIndex(x=>x.id===cursor);if(pos<0)return fail(400,'Bad request','Cursor inválido.');start=pos+1;}
        const items=all.slice(start,start+limit);return send(200,{items,nextCursor:start+limit<all.length?items.at(-1).id:null});
      }
      if(req.method!=='POST')return fail(405,'Method not allowed','Método no disponible.');
      if(resource==='content'&&user.role!=='docente')return fail(403,'Forbidden','Solo un docente puede publicar.');
      const key=req.headers['idempotency-key'];
      if(typeof key!=='string'||!/^[0-9a-f]{8}-[0-9a-f]{4}-[0-9a-f]{4}-[0-9a-f]{4}-[0-9a-f]{12}$/i.test(key))return fail(400,'Bad request','Idempotency-Key UUID requerida.');
      if(!/^application\/json(?:\s*;|$)/i.test(req.headers['content-type']||''))return fail(400,'Bad request','Se requiere JSON.');
      let raw='';for await(const chunk of req){raw+=chunk;if(Buffer.byteLength(raw)>16384){return fail(400,'Bad request','Cuerpo demasiado grande.');}}
      let input;try{input=JSON.parse(raw);}catch{return fail(400,'Bad request','JSON inválido.');}
      if(!input||typeof input!=='object'||Array.isArray(input))return fail(422,'Unprocessable entity','Datos inválidos.');
      const scope=JSON.stringify([school,user.sub,course,resource,key]), hash=createHash('sha256').update(JSON.stringify(Object.entries(input).sort(([a],[b])=>a.localeCompare(b)))).digest('hex');
      const findPrior=()=>db.prepare('SELECT * FROM idem WHERE scope=? AND expires>?').get(scope,Date.now());
      const replay=prior=>prior.fingerprint===hash?send(201,JSON.parse(prior.body),prior.location):fail(409,'Conflict','Clave reutilizada con otro payload.');
      let prior=findPrior();if(prior)return replay(prior);
      const validText=(value,max)=>typeof value==='string'&&value.trim().length>0&&value.length<=max;
      let result;
      if(resource==='content'){
        if(!validText(input.title,200)||!validText(input.fileUrl,2048)||(input.description!==undefined&&!validText(input.description,2000)))return fail(422,'Unprocessable entity','Material inválido.');
        try{const link=new URL(input.fileUrl);if(link.protocol!=='https:'||link.username||link.password)throw Error();}catch{return fail(422,'Unprocessable entity','URL HTTPS requerida.');}
        result={id:'cnt_'+randomUUID(),title:input.title,fileUrl:input.fileUrl,createdAt:new Date().toISOString(),...(input.description===undefined?{}:{description:input.description})};
      }else{
        if(!validText(input.question,2000))return fail(422,'Unprocessable entity','Pregunta inválida.');
        const reply=await answerTutor(input.question,getContents(school,course),{model});
        result={id:'tq_'+randomUUID(),answer:reply.answer,contentIds:reply.contentIds};res.setHeader('X-Tutor-Mode',reply.mode);
      }
      prior=findPrior();if(prior)return replay(prior);
      const location=path+'/'+result.id;
      db.prepare('BEGIN IMMEDIATE').run();
      try{
        if(resource==='content')db.prepare('INSERT INTO content VALUES (?,?,?,?,?,?,?)').run(school,course,result.id,result.title,result.description??null,result.fileUrl,result.createdAt);
        db.prepare('DELETE FROM idem WHERE expires<=?').run(Date.now());
        db.prepare('INSERT INTO idem VALUES (?,?,?,?,?)').run(scope,hash,JSON.stringify(result),location,Date.now()+86400000);db.prepare('COMMIT').run();
      }catch(e){db.prepare('ROLLBACK').run();throw e;}
      return send(201,result,location);
    }catch{if(!res.headersSent)fail(503,'Service unavailable','Servicio temporalmente no disponible.');else res.end();}
  });
  server.requestTimeout=25000; server.headersTimeout=5000;
  return {server,db,close:()=>new Promise((resolve,reject)=>server.close(e=>{db.close();e?reject(e):resolve();}))};
}
if(process.argv[1]===fileURLToPath(import.meta.url)) {
  const secret=process.env.S18_SECRET;
  if(process.argv[2]==='token') {if(!secret||Buffer.byteLength(secret)<32)throw Error('Configura S18_SECRET'); console.log(issueToken(secret,process.argv[3]));}
  else {const app=createAcademicServer({secret,dbPath:process.env.S18_DB||'aulaviva-s18.sqlite',model:process.env.S18_OLLAMA_MODEL||''});app.server.listen(Number(process.env.S18_PORT||8081),process.env.S18_HOST||'127.0.0.1',()=>console.log('Staging académico en puerto '+(process.env.S18_PORT||8081)));process.once('SIGTERM',()=>app.close());process.once('SIGINT',()=>app.close());}
}
