import {readFile,writeFile} from 'node:fs/promises';
import {contextPrompt,retrieve,requestLocalModel} from './tutor.mjs';
const model=process.env.S18_OLLAMA_MODEL;
if(!model)throw Error('S18_OLLAMA_MODEL requerido');
const golden=JSON.parse(await readFile(new URL('../../docs/ai/golden-set.json',import.meta.url),'utf8'));
const corpus=golden.materials.map(x=>({...x,id:x.key}));
async function measure(question,sources){
 const response=await requestLocalModel({model,stream:false,options:{temperature:0,seed:42,num_predict:1,num_ctx:2048},messages:[{role:'user',content:contextPrompt(question,sources)}]});
 if(!response.ok)throw Error('Ollama HTTP '+response.status);
 const result=await response.json();
 if(!Number.isInteger(result.prompt_eval_count)||result.prompt_eval_count<=0)throw Error('Sin métrica de tokens');
 return {tokens:result.prompt_eval_count,totalDurationNs:result.total_duration,evalCount:result.eval_count};
}
const rows=[];
for(const m of corpus){
 const question=golden.cases.find(c=>c.expected===m.key).question;
 const selected=retrieve(question,corpus);
 rows.push({material:m.key,full:await measure(question,corpus),selected:await measure(question,selected),duplicated:await measure(question,[...selected,...selected]),deduplicated:await measure(question,selected)});
}
const totals=Object.fromEntries(['full','selected','duplicated','deduplicated'].map(k=>[k,rows.reduce((sum,row)=>sum+row[k].tokens,0)]));
const out={model,scope:'5 prompts sintéticos; num_predict=1; tokens de entrada medidos por Ollama, no costo facturado ni calidad generativa; duplicación controlada',commit:process.env.GITHUB_SHA||'local',totals,rows};
await writeFile(new URL('../../docs/evidencias/s18/finops-llm-results.json',import.meta.url),JSON.stringify(out,null,2)+'\n');console.log(JSON.stringify(out,null,2));
