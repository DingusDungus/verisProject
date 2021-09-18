const { doesNotMatch } = require('assert');
var assert = require('assert');
const website = require("../src/website.js");

describe('Manage lab equipment', async function() {
  describe('#add()', async function() {
    it('Name should be scalpel and description should be the same as stated', async function() {
      await website.addEquipment("Scalpel", "Sharp blade made for cutting things");
      let result = website.addEquipmentTest();
      console.log(result);
      assert.equal(result, ["Scalpel", "Sharp blade made for cutting things"]);
    });
  });
});