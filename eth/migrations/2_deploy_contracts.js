const USTreasuryToken = artifacts.require("./USTreasuryToken.sol")
const SecurityToken   = artifacts.require("./SecurityToken.sol")
const Registry        = artifacts.require("./Registry.sol")

module.exports = function(deployer, network, [owner]) {
  deployer.then(async () => {
    // Deploy registry
    const registry = await deployer.deploy(Registry, {
      from: owner,
    })

    // Deploy public-facing proxy contract
    const token = await deployer.deploy(USTreasuryToken, registry.address, {
      from: owner,
    })

    // Deploy security token implementation
    const version = await deployer.deploy(SecurityToken, registry.address, {
      from: owner,
    })

    // Set initial security contract implementation version
    await token.setVersion(version.address)
  })
}
