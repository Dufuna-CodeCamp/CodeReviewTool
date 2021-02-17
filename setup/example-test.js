const { doesNotMatch } = require('assert');
var assert = require('assert');
var webdriver = require('selenium-webdriver');
var driver = new webdriver.Builder()
    .forBrowser('chrome')
    .build();

describe('Test Suite', function() {
    before(function() {
        pageUrl = 'http://local.selenium-test.com';
        driver.get(pageUrl);
    });
    
    after(function() {
        driver.quit();
    });
    
    it('test case: assert image amount is 2', async function() {
        const images = (await driver).findElements(webdriver.By.css('img'));
        const size = (await images).length;
        assert.strictEqual(size, 2, `Amount of images on the page not equal to ${images} `);
    });

    it('test case: ordered list available', async function() {
        const list = (await driver).findElements(webdriver.By.css('ol'));
        assert.notStrictEqual(list.length, 0, 'No ordered list on this page');
    });
});
