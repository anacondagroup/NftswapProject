const secondContract = artifacts.require("SecondERC721");

module.exports = function (deployer) {
  deployer.deploy(secondContract);
};
