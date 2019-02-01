const HDWalletProvider = require('truffle-hdwallet-provider')
const utils = require('web3-utils')

let secrets = {}
try {
  secrets = require ('./secrets')
} catch (err) {
  console.log('No secrets.js found, using enviromental variables')
}

const INFURA_API_KEY      = process.env.INFURA_API_KEY      || secrets.infura
const MAINNET_PRIVATE_KEY = process.env.MAINNET_PRIVATE_KEY || secrets.mainnet
const ROPSTEN_PRIVATE_KEY = process.env.ROPSTEN_PRIVATE_KEY || secrets.ropsten

const mainnetProvider = new HDWalletProvider(MAINNET_PRIVATE_KEY, `https://mainnet.infura.io/${INFURA_API_KEY}`)
const ropstenProvider = new HDWalletProvider(ROPSTEN_PRIVATE_KEY, `https://ropsten.infura.io/${INFURA_API_KEY}`)

module.exports = {
  networks: {
    development: {
      host: 'localhost',
      port: 8545,
      network_id: '*',
    },
    mainnet: {
      network_id: 1,
      provider: () => mainnetProvider,
      // from: ownerAddress,
      // gas: 4712388
      // gasPrice: utils.toWei ('100', 'shannon'),
    },
    ropsten: {
      network_id: 3,
      provider: () => ropstenProvider,
      gas: 4500000,
      gasPrice: utils.toWei ('100', 'gwei'),
    },
  },
  mocha: {
    reporter: 'spec',
  },
  solc: {
    optimizer: {
      enabled: true,
      runs: 200,
    },
  },
}
