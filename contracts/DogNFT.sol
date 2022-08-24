// SPDX-License-Identifier: GPL-3.0
pragma solidity ^0.5.0;

import "https://github.com/OpenZeppelin/openzeppelin-contracts/blob/release-v2.5.0/contracts/token/ERC721/ERC721Full.sol";

contract DogNFT is ERC721Full {
    constructor() public ERC721Full("DogRegistryToken", "DOG") {}

    modifier onlyPuppyOwner(address puppyOwner,uint tokenId){
        require(ownerOf(tokenId) == msg.sender, "Only puppy token owner can call this function.");
        require(puppyOwner == msg.sender, "You are not a registered owner of this puppy.");
        _;
    }

    struct Dog {
        string name;
        string breed;
        string dame;
        string sire;
        uint256 appraisalValue;
        string image;
    }

    mapping(uint256 => Dog) public dogCollection;

    event Appraisal(uint256 tokenId, uint256 appraisalValue, string reportURI, string image);
    
    function imageUri(
        uint256 tokenId

    ) public view returns (string memory imageURI){
        return dogCollection[tokenId].image;
    }

    function registerDog(
        address owner,
        string memory name,
        string memory breed,
        string memory dame, 
        string memory sire,
        uint256 initialAppraisalValue,
        string memory tokenURI,
        string memory tokenJSON
    ) public returns (uint256) {
        uint256 tokenId = totalSupply();

        _mint(owner, tokenId);
        _setTokenURI(tokenId, tokenURI);

        dogCollection[tokenId] = Dog(name, breed, dame, sire, initialAppraisalValue, tokenJSON);

        return tokenId;
    }

    function newAppraisal(
        uint256 tokenId,
        uint256 newAppraisalValue,
        string memory reportURI,
        string memory tokenJSON
        
    ) public onlyPuppyOwner(msg.sender, tokenId) returns (uint256) {
        dogCollection[tokenId].appraisalValue = newAppraisalValue;

        emit Appraisal(tokenId, newAppraisalValue, reportURI, tokenJSON);

        return (dogCollection[tokenId].appraisalValue);
    }
}