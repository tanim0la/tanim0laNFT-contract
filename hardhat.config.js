require('@nomicfoundation/hardhat-toolbox')
require('@nomiclabs/hardhat-etherscan')
require('dotenv').config()

/** @type import('hardhat/config').HardhatUserConfig */
module.exports = {
  solidity: '0.8.9',
  networks: {
    rinkeby: {
      url: process.env.NETWORK,
      accounts: [process.env.PRIVATE_KEY],
    },
  },
  etherscan: {
    // Your API key for Etherscan
    // Obtain one at https://etherscan.io/
    apiKey: process.env.API_KEY,
  },
}
