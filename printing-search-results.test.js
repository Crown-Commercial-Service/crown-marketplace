describe('Printing search results', () => {
  beforeAll(async () => {
    await page.goto('http://localhost:3000/branches?hire_via_agency=yes&nominated_worker=yes&postcode=tw12+2ew&school_payroll=');
  });

  it('should display download links', async () => {
    const element = await page.$('.file-download');

    const offsetHeight = await element.getProperty('offsetHeight');
    const offsetWidth = await element.getProperty('offsetWidth');
    const offsetHeightValue = await offsetHeight.jsonValue();
    const offsetWidthValue = await offsetWidth.jsonValue();

    await expect(offsetHeightValue).not.toEqual(0);
    await expect(offsetWidthValue).not.toEqual(0);
  });

  it('should not display download links when printing', async () => {
    await page.emulateMedia('print');

    const element = await page.$('.file-download');

    const offsetHeight = await element.getProperty('offsetHeight');
    const offsetWidth = await element.getProperty('offsetWidth');
    const offsetHeightValue = await offsetHeight.jsonValue();
    const offsetWidthValue = await offsetWidth.jsonValue();

    await expect(offsetHeightValue).toEqual(0);
    await expect(offsetWidthValue).toEqual(0);
  });
});
