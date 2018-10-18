const puppeteer = require('puppeteer');

(async () => {
  const browser = await puppeteer.launch();
  const page = await browser.newPage();
  await page.goto('http://localhost:3000/branches?hire_via_agency=yes&nominated_worker=yes&postcode=tw12+2ew&school_payroll=');

  // Toggle print mode to observe showing/hiding of elements
  // await page.emulateMedia('print');

  const element = await page.$('.file-download');

  // Use offsetHeight and offsetWidth to check whether element is visible
  // https://makandracards.com/makandra/1339-check-whether-an-element-is-visible-or-hidden-with-javascript
  const offsetHeight = await element.getProperty('offsetHeight');
  const offsetWidth = await element.getProperty('offsetWidth');
  await console.log(await offsetHeight.jsonValue());
  await console.log(await offsetWidth.jsonValue());

  await browser.close();
})();
