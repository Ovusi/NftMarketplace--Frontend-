// SPDX-License-Identifier: MIT

pragma solidity ^0.8.0;

import "@openzeppelin/contracts/token/ERC721/ERC721.sol";
import "@openzeppelin/contracts/token/ERC721/IERC721.sol";
import "@openzeppelin/contracts/token/ERC721/extensions/ERC721URIStorage.sol";
import "@openzeppelin/contracts/utils/Counters.sol";
import "@openzeppelin/contracts/access/Ownable.sol";
import "@openzeppelin/contracts/token/ERC721/extensions/ERC721Enumerable.sol";
import "@openzeppelin/contracts/utils/math/SafeMath.sol";

contract NFT is ERC721URIStorage, ERC721Enumerable, Ownable {
    // Create new nft collection
    using SafeMath for uint256;
    using Counters for Counters.Counter;
    Counters.Counter private _tokenIds;

    event Minted(address add, string uri);

    address public contractAddress;
    address payable _owner;
    string _name;
    string _symbol;
    bytes _data;

    uint256 public constant MAX_SUPPLY = 100;
    uint256 public constant PRICE = 0.01 ether;
    uint256 public constant MAX_PER_MINT = 5;


    string public baseTokenURI;

    function _beforeTokenTransfer(
        address from,
        address to,
        uint256 tokenId
    ) internal override(ERC721, ERC721Enumerable) {
        super._beforeTokenTransfer(from, to, tokenId);
    }

    function _burn(uint256 tokenId)
        internal
        override(ERC721, ERC721URIStorage)
    {
        super._burn(tokenId);
    }

    function tokenURI(uint256 tokenId)
        public
        view
        override(ERC721, ERC721URIStorage)
        returns (string memory)
    {
        return super.tokenURI(tokenId);
    }

    function supportsInterface(bytes4 interfaceId)
        public
        view
        override(ERC721, ERC721Enumerable)
        returns (bool)
    {
        return super.supportsInterface(interfaceId);
    }

    constructor(
        address marketAddress,
        address payable senderAdd,
        string memory name,
        string memory sym
    ) ERC721(_name, _symbol) {
        contractAddress = marketAddress;
        _owner = senderAdd;
        _symbol = sym;
        _name = name;
    }

    function mintNft(string memory tokenURI_)
        external
        returns (
            uint256,
            string memory,
            bool
        )
    {
        // mint new nft to collection
        _tokenIds.increment();

        uint256 newItemId = _tokenIds.current();
        _safeMint(_owner, newItemId);
        _setTokenURI(newItemId, tokenURI_); // TokenUri contains nft metadata e.g name,
        // description, image url,
        setApprovalForAll(contractAddress, true);

        emit Minted(_owner, tokenURI_);
        return (newItemId, tokenURI_, true);
    }

    function mintBatchWithURI(
        address[] memory recipients,
        string[] memory tokenURIList
    )
        external
        virtual
        returns (
            uint256,
            string[] memory,
            bool
        )
    {
        recipients[0] = _owner;
        uint256 newItemId = _tokenIds.current();

        for (uint256 i = 0; i < recipients.length; i++) {
            _safeMint(_owner, newItemId);
            _setTokenURI(newItemId, tokenURIList[i]); // TokenUri contains nft metadata e.g name,
            // description, image url,
            setApprovalForAll(contractAddress, true);
            _tokenIds.increment();

            emit Minted(_owner, tokenURIList[i]);
        }
        return (newItemId, tokenURIList, true);

    }

    function tokensOfOwner(address token_owner)
        external
        view
        returns (uint256[] memory)
    {
        uint256 tokenCount = balanceOf(token_owner);
        uint256[] memory tokensId = new uint256[](tokenCount);
        for (uint256 i = 0; i < tokenCount; i++) {
            tokensId[i] = tokenOfOwnerByIndex(token_owner, i);
        }

        return tokensId;
    }
}
