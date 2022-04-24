const { expect } = require("chai");
const { ethers } = require("hardhat");

describe("PunkDNA", function () {
    let punk_dna;
    let dna = "98500076866102862438511243873201350507055493981987690719374768781574322810666";
    beforeEach(async function() {
        const PunkDNA = await ethers.getContractFactory("$PunkDNA");        // Required to get access to internal functions
        punk_dna = await PunkDNA.deploy();
        await punk_dna.deployed();
    });

    it('should get DNA section', async() => {
        expect(await punk_dna.$_getDNASection(dna, 0)).to.equal(66);
        expect(await punk_dna.$_getDNASection(dna, 2)).to.equal(6);
        expect(await punk_dna.$_getDNASection(dna, 4)).to.equal(81);
        expect(await punk_dna.$_getDNASection(dna, 6)).to.equal(22);
        expect(await punk_dna.$_getDNASection(dna, 8)).to.equal(43);
        expect(await punk_dna.$_getDNASection(dna, 10)).to.equal(57);
        expect(await punk_dna.$_getDNASection(dna, 12)).to.equal(81);
        expect(await punk_dna.$_getDNASection(dna, 14)).to.equal(87);
        expect(await punk_dna.$_getDNASection(dna, 16)).to.equal(76);
        expect(await punk_dna.$_getDNASection(dna, 18)).to.equal(74);
        expect(await punk_dna.$_getDNASection(dna, 20)).to.equal(93);
        expect(await punk_dna.$_getDNASection(dna, 22)).to.equal(71);
        expect(await punk_dna.$_getDNASection(dna, 24)).to.equal(90);
    })

    it('should get deterministic PseudoRandom DNA', async() => {
        const [signer] = await ethers.getSigners();
        expect(await punk_dna.deterministicPseudoRandomDNA(1, signer.address)).to.be.an('object');
        expect(await punk_dna.deterministicPseudoRandomDNA(1, signer.address).toString().length).to.equal(16);
    })

    xit('', async() => {

    })
});