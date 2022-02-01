const puppeteer = require('puppeteer');
const { DOMAIN_NAME } = 'joshscloudresume.net';

const sleep = async (r) => await new Promise(r => setTimeout(r, 2000));

(async () => {
    const browser = await puppeteer.launch();
    const page = await browser.newPage();
    const website = `http://joshscloudresume.net`
    console.log(`Loading: ${website}`)
    await page.goto(website)
    console.log(`Waiting for API calls to be made`)
    await sleep(2000)
    const element = await page.$("#body")
    const property = await element.getProperty('innerHTML');
    const count = await property.jsonValue();
    console.log(`Getting page element, count: ${count}`)
    if (!count) {
        throw new Error("Cannot find count value")
    } else {
        console.log("PASS");
    }
    await browser.close();
})();