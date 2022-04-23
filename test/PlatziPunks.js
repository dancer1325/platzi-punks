const { expect } = require("chai");

describe("Platzi Punks Contract", () => {
  const setup = async ({ maxSupply = 1000 } = {}) => {
    const [owner] = await ethers.getSigners();
    const PlatziPunks = await ethers.getContractFactory("PlatziPunks");
    const deployed = await PlatziPunks.deploy(maxSupply);

    return {
      owner,
      deployed,
    };
  };

  describe("Deployment", () => {
    it("Check constructor functionality", async () => {
      const maxSupply = 10000;

      const { deployed } = await setup({ maxSupply });
      console.log(deployed);

      const returnedMaxSupply = await deployed.maxSupply();       // Getter function is created automatically for each contract's attribute
      expect(maxSupply).to.equal(returnedMaxSupply);

      const name = await deployed.name();
      expect(name).to.equal("PlatziPunks");

      const symbol = await deployed.symbol();
      expect(symbol).to.equal("PLPKS");
    });
  });

  describe("Minting", () => {
    it("Mints a new token and assigns to owner", async () => {
      const { owner, deployed } = await setup();

      await deployed.mint();
      const ownerOfMinted = await deployed.ownerOf(0);
      expect(ownerOfMinted).to.equal(owner.address);
    });

    it("Has a minting limit", async () => {
      const maxSupply = 2;

      const { deployed } = await setup({
        maxSupply,
      });

      // Mint all
      await Promise.all(new Array(2).fill().map(() => deployed.mint()));

      // Test last minting
      await expect(deployed.mint()).to.be.revertedWith(
        "There are no PlatziPunks left :("
      );
    });
  });

  describe("tokenURI", () => {
    it("returns valid metadata", async () => {
      const { deployed } = await setup();

      await deployed.mint();
      const tokenURI = await deployed.tokenURI(0);
      const stringifiedTokenURI = await tokenURI.toString();
      const [, base64JSON] = stringifiedTokenURI.split(
        "data:application/json;base64,"
      );
      const stringifiedMetadata = await Buffer.from(
        base64JSON,
        "base64"
      ).toString("ascii");
      const metadata = JSON.parse(stringifiedMetadata);

      expect(metadata).to.have.all.keys("name", "description", "image");
    });
  });
});
