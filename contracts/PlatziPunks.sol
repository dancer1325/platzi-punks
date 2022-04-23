// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;                 // Used for OpenZeppelin in their smart contracts

import "@openzeppelin/contracts/token/ERC721/ERC721.sol";
import "@openzeppelin/contracts/utils/Counters.sol";            // Utility to manage the counter
import "@openzeppelin/contracts/token/ERC721/extensions/ERC721Enumerable.sol";
import "@openzeppelin/contracts/finance/PaymentSplitter.sol";
import "@openzeppelin/contracts/utils/Strings.sol";
import "./Base64.sol";
import "./PunkDNA.sol";

// is                   Reserved keyword in Solidity to handle the inheritance
// ERC721               Core one
// ERC721Enumerable     Another interface based on ERC721, to extend functionality
// PunkDNA
// TODO: Fix problem running tests, after adding it
//contract PlatziPunks is ERC721, ERC721Enumerable, PunkDNA, PaymentSplitter {
contract PlatziPunks is ERC721, ERC721Enumerable, PunkDNA{
    using Counters for Counters.Counter;
    using Strings for uint256;

    Counters.Counter private _idCounter;            // Openzeppelin's type
    uint256 public maxSupply;                       // NFT's supply is unlimited, but you can restrict it, to give exclusivity
    mapping(uint256 => uint256) public tokenDNA;    // tokenId --> tokenDNA

    // Required to execute the inherited constructor
    // ERC721("NameOfTheToken", "SymbolOfTheToken")
    // TODO: Fix problem running tests, after adding it
//    constructor(address[] memory _payees, uint256[] memory  _shares, uint256 _maxSupply) ERC721("PlatziPunks", "PLPKS") PaymentSplitter(_payees, _shares) payable {
    constructor(uint256 _maxSupply) ERC721("PlatziPunks", "PLPKS") {
        maxSupply = _maxSupply;
    }

    // Create the token
    function mint() public {
        uint256 current = _idCounter.current();         // .current()       Function to return the current counter's value
        require(current < maxSupply, "There are no PlatziPunks left :(");       // Validation in order to restrict the number of NFT to create

        // msg.sender           Address which executes the function
        tokenDNA[current] = deterministicPseudoRandomDNA(current, msg.sender);  // Assign a new token based on deterministicPseudoRandomDNA
        _idCounter.increment();
        _safeMint(msg.sender, current);         // Private Open Zeppelin method, to create a token. Emits a Transfer event
    }

    // Override an Open Zeppelin's function
    // Base URI for computing tokenURI
    function _baseURI() internal pure override returns (string memory) {
        return "https://avataaars.io/";             // URI used to get the avatar
    }

    // It's NOT override function. It's a custom one
    function _paramsURI(uint256 _dna) internal view returns (string memory) {
        string memory params;

        // Important!! Based on the solidity compiler version, you can get Too Deep Stack error
        // 1) Params are intentionally scoped
        // 2) topType has been grouped outside t
        {
            params = string(
                abi.encodePacked(
                    "accessoriesType=",
                    getAccessoriesType(_dna),
                    "&clotheColor=",
                    getClotheColor(_dna),
                    "&clotheType=",
                    getClotheType(_dna),
                    "&eyeType=",
                    getEyeType(_dna),
                    "&eyebrowType=",
                    getEyeBrowType(_dna),
                    "&facialHairColor=",
                    getFacialHairColor(_dna),
                    "&facialHairType=",
                    getFacialHairType(_dna),
                    "&hairColor=",
                    getHairColor(_dna),
                    "&hatColor=",
                    getHatColor(_dna),
                    "&graphicType=",
                    getGraphicType(_dna),
                    "&mouthType=",
                    getMouthType(_dna),
                    "&skinColor=",
                    getSkinColor(_dna)
                )
            );
        }

        // Concatenate strings
        return string(abi.encodePacked(params, "&topType=", getTopType(_dna)));
    }

    // Concatenate the whole URI to get the image
    function imageByDNA(uint256 _dna) public view returns (string memory) {
        string memory baseURI = _baseURI();
        string memory paramsURI = _paramsURI(_dna);

        return string(abi.encodePacked(baseURI, "?", paramsURI));
    }

    // Override the ERC721Enumerable's function
    // Return the URI for the tokenId
    function tokenURI(uint256 tokenId)
        public
        view                                // Since it's just to display
        override                            // Required indicated to override it
        returns (string memory)
    {
        require(
            _exists(tokenId),               // OpenZeppelin's function
            "ERC721Metadata: URI query for nonexistent token"
        );

        uint256 dna = tokenDNA[tokenId];
        string memory image = imageByDNA(dna);

        // tokenURI must be in Base64
        string memory json = Base64.encode(
            bytes(
                string(
                    abi.encodePacked(
                        '{"name": "PlatziPunk #',
                        tokenId.toString(),
                        '", "description": "Platzi Punks are randomized Avataaars stored on chain to teach DApp development on Platzi", "image": "',
                        image,
                        '"}'
                    )
                )
            )
        );

        // Indicate the specification used
        return string(abi.encodePacked("data:application/json;base64,", json));
    }

    // Override required
    // Paste from Open Zeppelin wizard once you select that your smart contract inherit from Enumerable
    function _beforeTokenTransfer(
        address _from,
        address _to,
        uint256 _tokenId
    ) internal override(ERC721, ERC721Enumerable) {
        super._beforeTokenTransfer(_from, _to, _tokenId);
    }

    // Mark that smart contract inherits more than just ERC721
    // Paste from Open Zeppelin wizard once you select that your smart contract inherit from Enumerable
    function supportsInterface(bytes4 _interfaceId)
        public
        view
        override(ERC721, ERC721Enumerable)
        returns (bool)
    {
        return super.supportsInterface(_interfaceId);
    }
}
