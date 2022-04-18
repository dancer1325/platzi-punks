// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

// Contract to create the DNA -->
// 1) It doesn't require a constructor
// 2) All the properties are extracted from https://getavataaars.com/
contract PunkDNA {
    string[] private _accessoriesType = [
        "Blank",
        "Kurt",
        "Prescription01",
        "Prescription02",
        "Round",
        "Sunglasses",
        "Wayfarers"
    ];

    string[] private _clotheColor = [
        "Black",
        "Blue01",
        "Blue02",
        "Blue03",
        "Gray01",
        "Gray02",
        "Heather",
        "PastelBlue",
        "PastelGreen",
        "PastelOrange",
        "PastelRed",
        "PastelYellow",
        "Pink",
        "Red",
        "White"
    ];

    string[] private _clotheType = [
        "BlazerShirt",
        "BlazerSweater",
        "CollarSweater",
        "GraphicShirt",
        "Hoodie",
        "Overall",
        "ShirtCrewNeck",
        "ShirtScoopNeck",
        "ShirtVNeck"
    ];

    string[] private _eyeType = [
        "Close",
        "Cry",
        "Default",
        "Dizzy",
        "EyeRoll",
        "Happy",
        "Hearts",
        "Side",
        "Squint",
        "Surprised",
        "Wink",
        "WinkWacky"
    ];

    string[] private _eyebrowType = [
        "Angry",
        "AngryNatural",
        "Default",
        "DefaultNatural",
        "FlatNatural",
        "RaisedExcited",
        "RaisedExcitedNatural",
        "SadConcerned",
        "SadConcernedNatural",
        "UnibrowNatural",
        "UpDown",
        "UpDownNatural"
    ];

    string[] private _facialHairColor = [
        "Auburn",
        "Black",
        "Blonde",
        "BlondeGolden",
        "Brown",
        "BrownDark",
        "Platinum",
        "Red"
    ];

    string[] private _facialHairType = [
        "Blank",
        "BeardMedium",
        "BeardLight",
        "BeardMagestic",
        "MoustacheFancy",
        "MoustacheMagnum"
    ];

    string[] private _hairColor = [
        "Auburn",
        "Black",
        "Blonde",
        "BlondeGolden",
        "Brown",
        "BrownDark",
        "PastelPink",
        "Platinum",
        "Red",
        "SilverGray"
    ];

    string[] private _hatColor = [
        "Black",
        "Blue01",
        "Blue02",
        "Blue03",
        "Gray01",
        "Gray02",
        "Heather",
        "PastelBlue",
        "PastelGreen",
        "PastelOrange",
        "PastelRed",
        "PastelYellow",
        "Pink",
        "Red",
        "White"
    ];

    string[] private _graphicType = [
        "Bat",
        "Cumbia",
        "Deer",
        "Diamond",
        "Hola",
        "Pizza",
        "Resist",
        "Selena",
        "Bear",
        "SkullOutline",
        "Skull"
    ];

    string[] private _mouthType = [
        "Concerned",
        "Default",
        "Disbelief",
        "Eating",
        "Grimace",
        "Sad",
        "ScreamOpen",
        "Serious",
        "Smile",
        "Tongue",
        "Twinkle",
        "Vomit"
    ];

    string[] private _skinColor = [
        "Tanned",
        "Yellow",
        "Pale",
        "Light",
        "Brown",
        "DarkBrown",
        "Black"
    ];

    string[] private _topType = [
        "NoHair",
        "Eyepatch",
        "Hat",
        "Hijab",
        "Turban",
        "WinterHat1",
        "WinterHat2",
        "WinterHat3",
        "WinterHat4",
        "LongHairBigHair",
        "LongHairBob",
        "LongHairBun",
        "LongHairCurly",
        "LongHairCurvy",
        "LongHairDreads",
        "LongHairFrida",
        "LongHairFro",
        "LongHairFroBand",
        "LongHairNotTooLong",
        "LongHairShavedSides",
        "LongHairMiaWallace",
        "LongHairStraight",
        "LongHairStraight2",
        "LongHairStraightStrand",
        "ShortHairDreads01",
        "ShortHairDreads02",
        "ShortHairFrizzle",
        "ShortHairShaggyMullet",
        "ShortHairShortCurly",
        "ShortHairShortFlat",
        "ShortHairShortRound",
        "ShortHairShortWaved",
        "ShortHairSides",
        "ShortHairTheCaesar",
        "ShortHairTheCaesarSidePart"
    ];

    // This pseudo random function is deterministic --> should not be used in production
    // It's an alternative to generate really random via some 3º party such as ChainLink
    // _tokenId     sequential number
    // _minter      address which generates the token
    function deterministicPseudoRandomDNA(uint256 _tokenId, address _minter)
        public
        pure                // Modifier which doesn't read nor write parameters
        returns (uint256)
    {
        // Address === Hex composition derived from private key --> Easy to convert to number
        uint256 combinedParams = _tokenId + uint160(_minter);
        bytes memory encodedParams = abi.encodePacked(combinedParams);
        bytes32 hashedParams = keccak256(encodedParams);        // keccak256()      Function to compute the hash of a structured data

        return uint256(hashedParams);
    }

    // Get attributes
    // Each attribute's section is made of 2 digits
    uint8 constant ADN_SECTION_SIZE = 2;

    // _dna                 It's the complete chain
    // returns a DNA section === property, which are 2 digits
    // _rightDiscard        Attribute about the right part to the end discarded, to get the property
    function _getDNASection(uint256 _dna, uint8 _rightDiscard)
        internal            // Modifier which indicates that just this contract is going to use this function
        pure
        returns (uint8)
    {
        return
            uint8(                  // Force the parsing to return the desired type
                (_dna % (1 * 10**(_rightDiscard + ADN_SECTION_SIZE))) /         // **       It's a power
                    (1 * 10**_rightDiscard)
            );
    }

    // Functions to return each property

    function getAccessoriesType(uint256 _dna)
        public
        view
        returns (string memory)
    {
        uint256 dnaSection = _getDNASection(_dna, 0);           // accessoriesTypes represent the first 2 digits of DNA
        return _accessoriesType[dnaSection % _accessoriesType.length];      // Set a range between property's length --> Get the rest of dividing by property's length
    }

    function getClotheColor(uint256 _dna) public view returns (string memory) {
        uint256 dnaSection = _getDNASection(_dna, 2);           // clotheColor represent the [2,4] digits of DNA
        return _clotheColor[dnaSection % _clotheColor.length];  // Set a range between property's length --> Get the rest of dividing by property's length
    }

    function getClotheType(uint256 _dna) public view returns (string memory) {
        uint256 dnaSection = _getDNASection(_dna, 4);           // clotheType represent the [4, 6] digits of DNA
        return _clotheType[dnaSection % _clotheType.length];    // Set a range between property's length --> Get the rest of dividing by property's length
    }

    function getEyeType(uint256 _dna) public view returns (string memory) {
        uint256 dnaSection = _getDNASection(_dna, 6);           // eyeType represent the [6, 8] digits of DNA
        return _eyeType[dnaSection % _eyeType.length];          // Set a range between property's length --> Get the rest of dividing by property's length
    }

    function getEyeBrowType(uint256 _dna) public view returns (string memory) {
        uint256 dnaSection = _getDNASection(_dna, 8);           // eyebrowType represent the [8, 10] digits of DNA
        return _eyebrowType[dnaSection % _eyebrowType.length];  // Set a range between property's length --> Get the rest of dividing by property's length
    }

    function getFacialHairColor(uint256 _dna)
        public
        view
        returns (string memory)
    {
        uint256 dnaSection = _getDNASection(_dna, 10);          // facialHairColor represent the [10, 12] digits of DNA
        return _facialHairColor[dnaSection % _facialHairColor.length];  // Set a range between property's length --> Get the rest of dividing by property's length
    }

    function getFacialHairType(uint256 _dna)
        public
        view
        returns (string memory)
    {
        uint256 dnaSection = _getDNASection(_dna, 12);          // facialHairType represent the [12, 14] digits of DNA
        return _facialHairType[dnaSection % _facialHairType.length];    // Set a range between property's length --> Get the rest of dividing by property's length
    }

    function getHairColor(uint256 _dna) public view returns (string memory) {
        uint256 dnaSection = _getDNASection(_dna, 14);          // hairColor represent the [14, 16] digits of DNA
        return _hairColor[dnaSection % _hairColor.length];      // Set a range between property's length --> Get the rest of dividing by property's length
    }

    function getHatColor(uint256 _dna) public view returns (string memory) {
        uint256 dnaSection = _getDNASection(_dna, 16);          // hatColor represent the [16, 18] digits of DNA
        return _hatColor[dnaSection % _hatColor.length];        // Set a range between property's length --> Get the rest of dividing by property's length
    }

    function getGraphicType(uint256 _dna) public view returns (string memory) {
        uint256 dnaSection = _getDNASection(_dna, 18);          // graphicType represent the [18, 20] digits of DNA
        return _graphicType[dnaSection % _graphicType.length];  // Set a range between property's length --> Get the rest of dividing by property's length
    }

    function getMouthType(uint256 _dna) public view returns (string memory) {
        uint256 dnaSection = _getDNASection(_dna, 20);          // mouthType represent the [20, 22] digits of DNA
        return _mouthType[dnaSection % _mouthType.length];      // Set a range between property's length --> Get the rest of dividing by property's length
    }

    function getSkinColor(uint256 _dna) public view returns (string memory) {
        uint256 dnaSection = _getDNASection(_dna, 22);          // skinColor represent the [22, 24] digits of DNA
        return _skinColor[dnaSection % _skinColor.length];      // Set a range between property's length --> Get the rest of dividing by property's length
    }

    function getTopType(uint256 _dna) public view returns (string memory) {
        uint256 dnaSection = _getDNASection(_dna, 24);          // topType represent the [24, 26] digits of DNA
        return _topType[dnaSection % _topType.length];          // Set a range between property's length --> Get the rest of dividing by property's length
    }
}
