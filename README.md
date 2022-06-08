# Basic Sample Hardhat Project

This project demonstrates a basic Hardhat use case. It comes with a sample contract, a test for that contract, a sample script that deploys that contract, and an example of a task implementation, which simply lists the available accounts.

Try running some following tasks:
* `npx hardhat accounts`
* `npx hardhat compile`
  * Compile solidity code, generating a target based on the 'hardhat.config.js'
  * Command to check that all is working fine
* `npx hardhat clean`
* `npx hardhat test`
  * Run test
    * TODO: How to configure for launching test via IDE's editor configuration?
  * :warning: If you want to debug, you must execute the script 'test' from package.json 
* `npx hardhat node`
  * Open a console to interact with the smart contracts
* `node scripts/sample-script.js`
* `npx hardhat help`
* `npx hardhat flatten`
  * Take all the contracts, and flatten in 1 file
  * `npx hardhat flatten > Flattened.sol`
    * Create 'Flattened.sol' file with all the contracts


# How has the project been created?
* `yarn init / npm init`
* `yarn add hardhat -D / npm install --save-dev hardhat`
* `yarn add @nomiclabs/hardhat-waffle ethereum-waffle chai @nomiclabs/hardhat-ethers ethers -D / npm install --save-dev @nomiclabs/hardhat-waffle ethereum-waffle chai @nomiclabs/hardhat-ethers ethers`
* `npx hardhat`
  * Create some folders with some samples
    * 'contracts'
    * 'scripts'
    * 'test'

# How to run?
* `npx hardhat run scripts/deploy.js`
  * Run a script in hardhat environment, not in a net
* `npx hardhat run scripts/deploy.js --network rinkeby`
  * Run a script which deploys the smart contract in the net indicated
  * Previous to make the transaction you need ether
    * In testnet
      * https://www.rinkeby.io/#faucet
      * https://faucets.chain.link/

# Notes
* '.gitignore'
  * File pasted from typical template one https://github.com/github/gitignore/blob/main/Node.gitignore
* 'hardhat'
  * Ethereum development environment
  * It works fine for Node >=16
  * `npx hardhat`
    * Create your hardhat project
* 'ethers'
  * A complete Ethereum wallet implementation and utilities in JavaScript (and TypeScript).
* '@nomiclabs/hardhat-ethers'
  * Adapter of ethers for hardhat
* '@nomiclabs/hardhat-waffle'
  * Adapter of waffle for hardhat
* 'ethereum-waffle'
  * Framework for testing smart contracts
    * Alternative to truffle
* 'dotenv'
  * Manage environment variables, which aren't commited
  * '.env.example'
    * Template file to be shared by your team, but WITHOUT the real keys
* '@openzeppelin/contracts'
  * Library to secure the smart contract development
* 'Base64.sol'
  * Library created by a particular, to handle all about encoding in Base64 in solidity.
    * It's not included nor in Openzeppelin
    * How to use it?
      1) Create the file and paste the code
      2) Import the dependency
* 'chai'
  * DD / TDD assertion library for node and the browser
    * It can be delightfully paired with any javascript testing framework.
* 'hardhat-exposed'
  * Hardhat plugin to automatically expose internal functions for smart contract testing
  * After installing it, you would need to run 'hardhat compile --force'
  * Alternatives to use this package to test internal functions
    * https://medium.com/@danielque/solidity-unit-testing-internal-functions-4e9a728298a0
* 'artifacts'
  * .json file with the compiled smart contract with information as
    * net in which it's deployed
    * abi
  * Used in libraries such as
    * hardhat
    * truffle