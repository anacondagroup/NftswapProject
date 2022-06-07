// SPDX-License-Identifier: GPL-3.0

pragma solidity >=0.7.0 <0.9.0;

/**
 * @title ERC721 token
 * @dev Mint NFT tokens with pre-defined requirements. Assume that NFT token is uploaded to IPFS and tokenURI is the 
        value from IPFS URL.
 */

import "github.com/OpenZeppelin/openzeppelin-contracts/blob/release-v3.4/contracts/token/ERC721/ERC721.sol";

contract FirstERC721 is ERC721 {
    //The uniqueID of ERC721 token
    uint256 public tokenCounter;

    event MintToken (
        address owner,
        uint tokenId
    );

    //constructor which initializes the uniqueID, name and symbol
    constructor() ERC721("first", "FST") {
        tokenCounter = 0;
    }
    
    //mint one NFT with unique tokenURI
    function mintNFT(string memory tokenURI) public payable {
        //check if the sent ETH is bigger than 0.01 ether
        require(msg.value > 0.01 ether, "Not Enough Money");
        //increase tokenID
        tokenCounter ++;
        //access the value
        uint256 tokenId = tokenCounter;
        //mint NFT token to function caller
        _safeMint(msg.sender, tokenId);
        //emit Event
        MintToken(msg.sender, tokenId);
        //set tokenURI corresponding to tokenID
        _setTokenURI(tokenId, tokenURI);
    }
}