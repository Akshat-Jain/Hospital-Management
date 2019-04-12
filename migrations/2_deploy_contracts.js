var SimpleStorage = artifacts.require("./SimpleStorage.sol");
var InnovationLab = artifacts.require("./InnovationLab.sol");

module.exports = function(deployer) {
  deployer.deploy(InnovationLab);
  deployer.deploy(SimpleStorage);
};
