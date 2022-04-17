require("@nomiclabs/hardhat-waffle");
require("dotenv").config();     // By default it looks for the file '.env'

module.exports = {
  solidity: "0.8.4",
  networks: {             // Network to which one to connect
    rinkeby: {
      url: `https://rinkeby.infura.io/v3/${process.env.INFURA_PROJECT_ID}`,
      accounts: [`0x${process.env.DEPLOYER_PRIVATE_KEY}`],    // Required to add "0x"
    },
  },
};
