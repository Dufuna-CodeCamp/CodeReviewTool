var assert = require('assert');
var webdriver = require('selenium-webdriver');
var driver = new webdriver.Builder()
    .forBrowser('chrome')
    .build();

describe('Test Suite', function() {
    before(function() {
        pageUrl = 'file:///Users/folashadedaniel/Desktop/dufuna/CodeReviewTool/submissions/index.html'
        driver.get(pageUrl);
    });
    
    after(function() {
        driver.quit();
    });
    
    it('test case: assert image amount is 2', async function() {
        const images = (await driver).findElements(webdriver.By.css('img'));
        var size = (await images).length
        
        assert.strictEqual(size, 2, `Amount of images on the page not equal to 2`);
    });

    it('test case: ordered list available', async function() {
        const list = (await driver).findElements(webdriver.By.css('ol'));
        assert.notStrictEqual(list.length, 0, 'No ordered list on this page');
    });
});
