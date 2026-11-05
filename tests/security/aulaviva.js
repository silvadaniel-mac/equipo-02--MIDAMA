// Ejemplos sintéticos. Este archivo solo se analiza, nunca se ejecuta.
// ruleid: aulaviva-no-dynamic-code
eval(userInput);
// ruleid: aulaviva-no-dynamic-code
const dynamic = new Function('input', userInput);
// ok: aulaviva-no-dynamic-code
JSON.parse(userInput);
// ruleid: aulaviva-no-disabled-tls
process.env.NODE_TLS_REJECT_UNAUTHORIZED = '0';
// ruleid: aulaviva-no-disabled-tls
const insecure = { rejectUnauthorized: false, timeout: 5000 };
// ok: aulaviva-no-disabled-tls
const secure = { rejectUnauthorized: true, timeout: 5000 };
