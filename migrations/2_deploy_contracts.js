var IdeaFactory = artifacts.require("./IdeaFactory.sol");

module.exports = function(deployer) {
  deployer.deploy(IdeaFactory);
}
