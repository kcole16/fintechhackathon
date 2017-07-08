var MicroFinanceToken = artifacts.require("./MicroFinanceToken.sol");

module.exports = function(deployer) {
  deployer.deploy(MicroFinanceToken, ['0x74d80a2fa658641f53ae091f7f5d5949ca5ad515',
    '0x531ba86716cec2c33119a86eb44a8c1e1f83bcaa'], 1000, 'Test', 6000);
};
