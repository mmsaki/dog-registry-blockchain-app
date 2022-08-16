pragma solidity ^0.5.0;

import "https://github.com/OpenZeppelin/openzeppelin-contracts/blob/release-v2.5.0/contracts/token/ERC721/ERC721Full.sol";

contract ArtRegistry is ERC721Full {
    constructor() public ERC721Full("ArtRegistryToken", "ART") {}

    struct Artwork {
        string name;
        string artist;
        uint256 appraisalValue;
        string artJson;
    }

    mapping(uint256 => Artwork) public artCollection;

    event Appraisal(uint256 tokenId, uint256 appraisalValue, string reportURI, string artJson);
    
    function imageUri(
        uint256 tokenId

    ) public view returns (string memory imageJson){
        return artCollection[tokenId].artJson;
    }


    function registerArtwork(
        address owner,
        string memory name,
        string memory artist,
        uint256 initialAppraisalValue,
        string memory tokenURI,
        string memory tokenJSON
    ) public returns (uint256) {
        uint256 tokenId = totalSupply();

        _mint(owner, tokenId);
        _setTokenURI(tokenId, tokenURI);

        artCollection[tokenId] = Artwork(name, artist, initialAppraisalValue, tokenJSON);

        return tokenId;
    }

    function newAppraisal(
        uint256 tokenId,
        uint256 newAppraisalValue,
        string memory reportURI,
        string memory tokenJSON
        
    ) public returns (uint256) {
        artCollection[tokenId].appraisalValue = newAppraisalValue;

        emit Appraisal(tokenId, newAppraisalValue, reportURI, tokenJSON);

        return (artCollection[tokenId].appraisalValue);
    }
}
