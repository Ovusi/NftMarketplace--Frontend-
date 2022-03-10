// SPDX-License-Identifier: MIT

pragma solidity ^0.8.0;

import "@openzeppelin/contracts/token/ERC721/ERC721.sol";
import "@openzeppelin/contracts/token/ERC721/IERC721.sol";
import "@openzeppelin/contracts/token/ERC721/extensions/ERC721URIStorage.sol";
import "@openzeppelin/contracts/utils/Counters.sol";

contract NFT is ERC721URIStorage {
    // Create new nft collection
    using Counters for Counters.Counter;
    Counters.Counter private _tokenIds;

    event Minted(
        address add,
        string uri
    );

    address public contractAddress;
    address payable _owner;
    string _name;
    string _symbol;
    bytes _data;

    constructor(address marketAddress) ERC721("Haven NFT Marketplace", "HNM") {
        contractAddress = marketAddress;
    }

    function mintNft(string memory tokenURI) public returns (uint256) {
        // mint new nft to collection
        _tokenIds.increment();

        uint256 newItemId = _tokenIds.current();
        _safeMint(_owner, newItemId);
        _setTokenURI(newItemId, tokenURI); // TokenUri contains nft metadata e.g name,
        // description, image url,
        setApprovalForAll(contractAddress, true);

        emit Minted(_owner, tokenURI);
        return newItemId;
    }

    function balance(address owner_) public view {
        owner_ = _owner;
        balanceOf(owner_);
    }

    function owner(uint256 tokenid) public view {
        ownerOf(tokenid);
    }

    function uri(uint256 tokenid) public view {
        tokenURI(tokenid);
    }
}
