// SPDX-License-Identifier: MIT

pragma solidity ^0.8.0;

import "@openzeppelin/contracts/token/ERC721/ERC721.sol";
import "@openzeppelin/contracts/token/ERC721/IERC721.sol";
import "@openzeppelin/contracts/token/ERC721/extensions/ERC721URIStorage.sol";
import "@openzeppelin/contracts/utils/Counters.sol";
import "@openzeppelin/contracts/access/Ownable.sol";
import "@openzeppelin/contracts/token/ERC721/extensions/ERC721Enumerable.sol";
import "@openzeppelin/contracts/utils/math/SafeMath.sol";

contract NFT is ERC721, ERC721URIStorage, ERC721Enumerable, Ownable {
    // Create new nft collection
    using SafeMath for uint256;
    using Counters for Counters.Counter;
    Counters.Counter private _tokenIds;

    event Minted(address add, string uri);
    event MintedBatch(address add, string[]);
    event UriChanged(string description);
    event ProfileImagedChanged(string newhash);
    event CollNameChanged(string name);
    event SymChanged(string sym);

    address public contractAddress;
    address _owner;
    string public pictureHash;
    string public collectionUri;
    string _name;
    string _symbol;
    bytes _data;

    uint256 public constant MAX_SUPPLY = 10000;
    uint256 public constant MAX_PER_MINT = 5;

    mapping(uint => string) ids;
    uint[] id_list;

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
        string memory name,
        string memory sym
    ) ERC721(_name, _symbol) {
        _owner = msg.sender;
        _symbol = sym;
        _name = name;
    }

    function getImage() external view returns (string memory) {
        return pictureHash;
    }

    function updateImage(string memory newHash)
        external
        onlyOwner
        returns (string memory)
    {
        pictureHash = newHash;
        emit ProfileImagedChanged(pictureHash);
        return pictureHash;
    }

    function getCollectionUri() external view returns (string memory) {
        return collectionUri;
    }

    function updateCollectionUri(string memory newUri)
        external
        onlyOwner
        returns (string memory)
    {
        collectionUri = newUri;
        emit UriChanged(collectionUri);
        return collectionUri;
    }

    function getName() external view returns (string memory) {
        return _name;
    }

    function getSymbol() external view returns (string memory) {
        return _symbol;
    }

    function changeName(string memory newName)
        external
        onlyOwner
        returns (string memory)
    {
        _name = newName;
        emit CollNameChanged(_name);
        return _name;
    }

    function changeSymbol(string memory newSymbol)
        external
        onlyOwner
        returns (string memory)
    {
        _symbol = newSymbol;
        emit SymChanged(_symbol);
        return _symbol;
    }

    function mintNft(string memory tokenURI_)
        external
        onlyOwner
        returns (
            uint256,
            string memory,
            bool
        )
    {
        require(id_list.length < MAX_SUPPLY);
        _tokenIds.increment();

        uint256 newItemId = _tokenIds.current();
        _safeMint(_owner, newItemId);
        _setTokenURI(newItemId, tokenURI_);

        ids[newItemId] = tokenURI_;
        id_list.push(newItemId);

        emit Minted(_owner, tokenURI_);
        return (newItemId, tokenURI_, true);
    }

    function mintBatchWithURI(
        address[] memory recipients,
        string[] memory tokenURIList
    )
        external
        virtual
        onlyOwner
        returns (
            uint256,
            string[] memory,
            bool
        )
    {
        require(tokenURIList.length <= MAX_PER_MINT);
        require(id_list.length < MAX_SUPPLY);
        recipients[0] = _owner;
        uint256 newItemId = _tokenIds.current();

        for (uint256 i = 0; i < recipients.length; i++) {
            _safeMint(_owner, newItemId);
            _setTokenURI(newItemId, tokenURIList[i]);
            _tokenIds.increment();
        }
        emit MintedBatch(_owner, tokenURIList);
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

    function burnToken(uint256 tokenId) external returns (string memory) {
        require(msg.sender == _owner);
        _burn(tokenId);
        return ("Burned successfully");
    }
}
