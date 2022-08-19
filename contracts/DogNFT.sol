// SPDX-License-Identifier: GPL-3.0
pragma solidity ^0.5.0;

import "https://github.com/OpenZeppelin/openzeppelin-contracts/blob/release-v2.5.0/contracts/token/ERC721/ERC721Full.sol";
import "./DogRegistry.sol";

contract DogNFT is ERC721Full {
    constructor() public ERC721Full("DogRegistryToken", "DOG") {}

    struct Dog {
        string name;
        string breed;
        uint256 appraisalValue;
        string dogJson;
    }

    mapping(uint256 => Dog) public dogCollection;

    event Appraisal(uint256 tokenId, uint256 appraisalValue, string reportURI, string dogJson);
    
    function imageUri(
        uint256 tokenId

    ) public view returns (string memory imageJson){
        return dogCollection[tokenId].dogJson;
    }

    function registerDog(
        address owner,
        string memory name,
        string memory breed,
        uint256 initialAppraisalValue,
        string memory tokenURI,
        string memory tokenJSON
    ) public returns (uint256) {
        uint256 tokenId = totalSupply();

        _mint(owner, tokenId);
        _setTokenURI(tokenId, tokenURI);

        dogCollection[tokenId] = Dog(name, breed, initialAppraisalValue, tokenJSON);

        return tokenId;
    }

    function newAppraisal(
        uint256 tokenId,
        uint256 newAppraisalValue,
        string memory reportURI,
        string memory tokenJSON
        
    ) public returns (uint256) {
        dogCollection[tokenId].appraisalValue = newAppraisalValue;

        emit Appraisal(tokenId, newAppraisalValue, reportURI, tokenJSON);

        return (dogCollection[tokenId].appraisalValue);
    }
}