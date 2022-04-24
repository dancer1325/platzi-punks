const {expect} = require("chai");

describe("Platzi Punks Contract", () => {
    const setup = async ({maxSupply = 1000} = {}) => {
        const [owner] = await ethers.getSigners();
        const PlatziPunks = await ethers.getContractFactory("PlatziPunks");
        const deployed = await PlatziPunks.deploy(maxSupply);

        return {
            owner,
            deployed,
            PlatziPunks
        };
    };

    describe("Deployment", () => {
        it("Check constructor functionality", async () => {
            const maxSupply = 10000;

            const {deployed} = await setup({maxSupply});
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

        it("Mints a new token and assigns to owner, increasing the _idCounter", async () => {
            const {owner, deployed} = await setup();

            await deployed.mint();
            const ownerOfMinted = await deployed.ownerOf(0);      // .ownerOf   IERC721's function
            expect(ownerOfMinted).to.equal(owner.address);        // Checking _safeMint functionality from OpenZeppelin

            const counters = await deployed._idCounter();
            expect(counters).to.equal(1);
        });

        it("Has a minting limit", async () => {
            const maxSupply = 2;

            const {deployed} = await setup({
                maxSupply,
            });

            // Options to throw several promises

            // 1) Manually
            // await deployed.mint();
            // await deployed.mint();
            // await expect(deployed.mint()).to.be.revertedWith("There are no PlatziPunks left :(")

            // 2) Promise.all()    Iterable of promises to return a single one
            await Promise.all(new Array(2).fill().map(() => deployed.mint()));

            // Test last minting
            // revertedWith()   chai matcher applied via waffle, with hardhat's plugin.
            // Check if the transaction was reverted with certain message
            await expect(deployed.mint()).to.be.revertedWith(
                "There are no PlatziPunks left :("
            );
        });
    });

    describe("paramsURI", () => {
        // Test based on the determiniscPsuedo random property
        // First dna generated is always 98500076866102862438511243873201350507055493981987690719374768781574322810666
        it('should return URI params based on dna', async () => {
            const {deployed} = await setup();
            let dna = "98500076866102862438511243873201350507055493981987690719374768781574322810666";    // Important!!: Just valid sending as string, not as int
            // let dna = web3.utils.toBN(String(98500076866102862438511243873201350507055493981987690719374768781574322810666));
            const params = await deployed._paramsURI(dna);
            expect(params).equal("accessoriesType=Prescription02&clotheColor=Heather&clotheType=BlazerShirt&eyeType=Wink&eyebrowType=SadConcerned&facialHairColor=Black&facialHairType=BeardMagestic&hairColor=Platinum&hatColor=Blue01&graphicType=Bear&mouthType=Tongue&skinColor=Yellow&topType=LongHairMiaWallace");
        });
    })

    describe('imageByDNA', () => {
        // Test based on the determiniscPsuedo random property
        // First dna generated is always 98500076866102862438511243873201350507055493981987690719374768781574322810666
        it('should return imageByDNA', async () => {
            const {deployed} = await setup();
            let dna = "98500076866102862438511243873201350507055493981987690719374768781574322810666";
            let imageByDNA = await deployed.imageByDNA(dna);
            expect(imageByDNA).equal("https://avataaars.io/?accessoriesType=Prescription02&clotheColor=Heather&clotheType=BlazerShirt&eyeType=Wink&eyebrowType=SadConcerned&facialHairColor=Black&facialHairType=BeardMagestic&hairColor=Platinum&hatColor=Blue01&graphicType=Bear&mouthType=Tongue&skinColor=Yellow&topType=LongHairMiaWallace");
        });
    });

    describe("tokenURI", () => {
        it("returns valid metadata", async () => {
            const {deployed} = await setup();

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
            expect(tokenURI).to.includes(Buffer.from('{"name": "PlatziPunk #0').toString('base64').slice(0, -1));
        });

        it("Should throw an error if tokenId don't exists", async function () {
            const {deployed} = await setup(2);
            await deployed.deployed();
            try {
                await deployed.tokenURI(0)
                expect.fail('fail with an error');
            } catch (error) {
                expect(error.message).to.contains('ERC721Metadata: URI query for nonexistent token');
            }
        });
    });
});
