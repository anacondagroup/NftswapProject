// SPDX-License-Identifier: GPL-3.0

pragma solidity >=0.7.0 <0.9.0;

/**
 * @title ERC721 contrac
 * @dev mint NFT tokens and escrow and swap tokens.
 */
import "github.com/OpenZeppelin/openzeppelin-contracts/blob/release-v3.4/contracts/token/ERC721/ERC721.sol";

contract SecondERC721 is ERC721 {
    //unique tokenID of this contract
    uint256 public tokenCounter;

    //mapping that matches contract address with a mapping that matches uniqueID and constant value
    mapping(address => mapping(uint => address)) listToken;

    //constructor that initializes unique tokenID, name and symbol
    constructor() ERC721("second", "SCT") {
        tokenCounter = 0;
    }

    //event
    event MintSecondToken(
        uint tokenId,
        string tokenURI
    );

    //event
    event SwapToken(
        address owner,
        uint tokenId,
        uint secondId
    );

    //mint NFT token with pre-defined conditions but assume that minted Tokens remain in this contract
    //The owner of minted token is this contract not a caller(problem requirements)
    function mintNFT(string memory tokenURI) public payable {
        //The caller must send more than 0.01 ether to the contract.
        require(msg.value > 0.01 ether, "Not Enough Money");
        //increase tokenID
        tokenCounter ++;
        //access the value
        uint256 tokenId = tokenCounter;
        //mint a token to this contract
        _safeMint(address(this), tokenId);
        //set the tokenURI correspondint to tokenID
        _setTokenURI(tokenId, tokenURI);
        //emit an event
        MintSecondToken(tokenId, tokenURI);
    }

    //Escrow a token from another NFT token contract
    function escrowToken(address _contractAddr, uint256 _tokenId) public {
        //get the instance of ERC721 contract with address variable.
        ERC721 contract1 = ERC721(_contractAddr);
        //check if the caller is the owner of tokenID
        require(msg.sender == contract1.ownerOf(_tokenId), "Not the Owner");
        //set 1 in the listToken mapping which proves that the caller escrows a token
        listToken[_contractAddr][_tokenId] = msg.sender;
        //transfer the ownership from caller to this contract
        contract1.transferFrom(msg.sender, address(this), _tokenId);
    }
    
    //Get a secondToken in replace of firstToken
    function swapToken(address _contractAddr, uint256 _firstId, uint256 _secondId) public {
        //check if the tokenID of the second contract exisits
        require(_secondId <= tokenCounter, "Not exist in this contract");
        //check if the caller is the owner of contract address and tokenID is empty
        require(listToken[_contractAddr][_firstId] != address(0), "Not escrow yet");
        //transfer the second token to caller
        transferFrom(address(this), msg.sender, _secondId);
        //emit an event
        SwapToken(_contractAddr, _firstId, _secondId);
    }
}