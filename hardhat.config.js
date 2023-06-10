require("@nomicfoundation/hardhat-toolbox");
require("dotenv").config();

/** @type import('hardhat/config').HardhatUserConfig */
module.exports = {
  defaultNetwork: "mantle-testnet",
  solidity: "0.8.18",
  networks: {
    "mantle-testnet": {
      url: "https://rpc.testnet.mantle.xyz/",
      accounts: [process.env.PRIV_KEY],
    }
  }
};
