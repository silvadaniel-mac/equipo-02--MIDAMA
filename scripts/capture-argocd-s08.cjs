// Prueba visual ejecutada únicamente contra el Argo CD efímero de CI.
const { chromium } = require('playwright');
const path = require('node:path');
(async () => {
  const browser = await chromium.launch({ headless: true });
  const page = await browser.newPage({ viewport: { width: 1600, height: 1000 }, ignoreHTTPSErrors: true });
  await page.goto('https://127.0.0.1:8443', { waitUntil: 'networkidle' });
  await page.getByPlaceholder('Username', { exact: true }).fill('admin');
  await page.locator('input[type=password]').fill(process.env.ARGO_PASSWORD);
  await page.getByRole('button', { name: /sign in/i }).click();
  await page.getByText('aulaviva-dev', { exact: true }).first().waitFor();
  await page.screenshot({ path: path.join(process.env.OUTPUT_DIR, 'argocd-applications.png'), fullPage: true });
  await page.getByText('aulaviva-dev', { exact: true }).first().click();
  await page.getByText('Healthy', { exact: true }).first().waitFor();
  await page.getByText('Synced', { exact: true }).first().waitFor();
  await page.screenshot({ path: path.join(process.env.OUTPUT_DIR, 'argocd-synced-healthy.png'), fullPage: true });
  await browser.close();
})().catch(error => { console.error(error.message); process.exit(1); });
