const USTreasuryToken = artifacts.require("./USTreasuryToken.sol")
const SecurityToken   = artifacts.require("./SecurityToken.sol")
const Registry        = artifacts.require("./Registry.sol")

module.exports = function(deployer, network, [owner]) {
  deployer.then(async () => {
    // Deploy registry
    const registry = await deployer.deploy(Registry, {
      from: owner,
    })

    // Deploy security token implementation
    const version = await deployer.deploy(SecurityToken, {
      from: owner,
    })

    await version.setRegistry(registry.address)

    // // Deploy public-facing proxy contract
    // const contract = await deployer.deploy(USTreasuryToken, version.address, {
    //   from: owner,
    // })

    // const token = await SecurityToken.at(contract.address)
    // await token.setRegistry(registry.address)
  })
}
