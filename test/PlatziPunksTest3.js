// import {expect} from "chai";             // SyntaxError: Cannot use import statement outside a module
const { expect } = require("chai");

// Test for exposed contracts
describe("Platzi Punks exposed", () => {
    const setup = async ({maxSupply = 1000} = {}) => {
        const [owner] = await ethers.getSigners();
        const PlatziPunks = await ethers.getContractFactory("$PlatziPunks");
        const deployed = await PlatziPunks.deploy(maxSupply);

        return {
            owner,
            deployed,
        };
    };

    describe("_baseURI", () => {
        it('should return avataaars uri', async () => {
            const {deployed} = await setup();
            const baseURI = await deployed.$_baseURI();
            expect(baseURI).equal("https://avataaars.io/");
        });
    })
});