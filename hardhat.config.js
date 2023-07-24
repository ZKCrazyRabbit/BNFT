require("@nomicfoundation/hardhat-toolbox");
require("@nomiclabs/hardhat-truffle5");
require("dotenv").config();

/** @type import('hardhat/config').HardhatUserConfig */
module.exports = {
  solidity: "0.8.18",
  defaultNetwork: "mantle-testnet",
  networks: {
    "mantle-testnet": {
      url: "https://rpc.testnet.mantle.xyz/",
      accounts: [process.env.TEST_PRIV_KEY],
    },
    "mantle-mainnet": {
      url: "https://rpc.mantle.xyz/",
      accounts: [process.env.PRIV_KEY],
    }
  }
};
