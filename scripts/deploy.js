const deploy = async () => {
    // Once you execute `npx hardhat run ...`, having added '@nomiclabs/hardhat-ethers'
    // --> Information has been added to execution context, such as ethers object is available for the global context
  const [deployer] = await ethers.getSigners();         // getSigners() is a method added by '@nomiclabs/hardhat-ethers'

  console.log("Deploying contracts with the account:", deployer.address);

  const PlatziPunks = await ethers.getContractFactory("PlatziPunks");   // getContractFactory() is a method added by '@nomiclabs/hardhat-ethers'
  const deployed = await PlatziPunks.deploy(10000);         // .deploy()        You can pass the same arguments as the contract's constructor https://docs.ethers.io/v5/api/contract/contract-factory/#ContractFactory-deploy

  console.log("Platzi Punks address:", deployed.address);
};

deploy()
  .then(() => process.exit(0))
  .catch((error) => {
    console.error(error);
    process.exit(1);
  });
