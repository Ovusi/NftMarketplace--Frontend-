// SPDX-License-Identifier: MIT

pragma solidity ^0.8.0;

import "@openzeppelin/contracts/token/ERC721/ERC721.sol";
import "@openzeppelin/contracts/token/ERC721/IERC721.sol";
import "@openzeppelin/contracts/token/ERC721/extensions/ERC721URIStorage.sol";
import "@openzeppelin/contracts/utils/Counters.sol";

contract NFT is ERC721URIStorage {
    using Counters for Counters.Counter;
    Counters.Counter private _tokenIds;

    address payable _owner;
    string _name;
    string _symbol;
    bytes _data;

    constructor() ERC721("", "") {}

    function mintNft(string memory tokenURI) public returns (uint256) {
        _tokenIds.increment();
        uint256 newItemId = _tokenIds.current();
        _mint(_owner, newItemId);
        _setTokenURI(newItemId, tokenURI);

        return newItemId;
    }

    function balance(address owner_) public view {
        owner_ = _owner;
        balanceOf(owner_);
    }

    function owner(uint tokenid) public view {
        ownerOf(tokenid);
    }

}
