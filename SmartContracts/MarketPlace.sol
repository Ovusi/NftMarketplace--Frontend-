// SPDX-License-Identifier: MIT

pragma solidity ^0.8.9;

import "@openzeppelin/contracts/token/ERC20/ERC20.sol";
import "@openzeppelin/contracts/token/ERC20/IERC20.sol";
import "@openzeppelin/contracts/utils/Counters.sol";
import "@openzeppelin/contracts/token/ERC721/IERC721.sol";
import "@openzeppelin/contracts/utils/math/Math.sol";
import "@openzeppelin/contracts/finance/PaymentSplitter.sol";

abstract contract HavenMarketPlace is IERC721 {

// STATE VARIABLES
    using Counters for Counters.Counter;
    Counters.Counter private _tokenIds;

    event Listed(address newToken, uint256 id, uint256 price);
    event deListed(address owner, uint256 id);
    event Bought(address buyer, uint256 price, uint256 id);
    event Auctioned(address newToken, uint id, uint startPrice);

    enum status {
        open,
        sold,
        canceled
    }

    struct Listing {
        status status;
        address seller;
        address nftContract;
        uint256 tokenId;
        uint256 price;
    }

    Listing[] public itemsOnList; // todo
    mapping(address => mapping(uint256 => bool)) activeItems; // todo

    mapping(uint256 => Listing) public _listings;
    uint[] public itemsListed;


// HELPER FUNCTIONS
    function find(uint256 value) internal view returns (uint256) {
        uint256 i = 0;
        while (itemsListed[i] != value) {
            i++;
        }
        return i;
    }

    function removeByValue(uint256 value) internal {
        uint256 i = find(value);
        removeByIndex(i);
    }

    function removeByIndex(uint256 i) internal {
        while (i < itemsListed.length - 1) {
            itemsListed[i] = itemsListed[i + 1];
            i++;
        }
        itemsListed.pop();
    }

// CORE FUNCTIONS 

    function listNft(
        address token_,
        uint256 tokenid_,
        uint256 price_
    ) external returns (uint) {
        IERC721(token_).transferFrom(msg.sender, address(this), tokenid_);

        Listing memory listing = Listing(
            status.open,
            msg.sender,
            token_,
            tokenid_,
            price_
        );
        _tokenIds.increment();

        uint256 newItemId = _tokenIds.current();
        _listings[newItemId] = listing;
        itemsListed.push(newItemId);

        emit Listed(token_, tokenid_, price_);
        return newItemId;
    }

    function buyNft(uint256 listingId_, address payable tokenContract_)
        external
        payable
        returns (bool)
    {
        Listing storage listing = _listings[listingId_];
        require(msg.sender != listing.seller);
        require(msg.value >= listing.price);
        require(listing.status == status.open);
        require(tokenContract_ != msg.sender);
        require(tokenContract_ != listing.seller);

        uint256 fee = (msg.value * 2) / 100;
        uint256 commision = msg.value - fee;

        listing.status = status.sold;

        IERC721(listing.nftContract).transferFrom(
            address(this),
            msg.sender,
            listing.tokenId
        );
        payable(listing.seller).transfer(commision);
        payable(tokenContract_).transfer(fee);

        emit Bought(msg.sender, msg.value, listing.tokenId);

        return true;
    }

    function cancelListing(uint256 lId) external payable returns (bool, string memory) {
        Listing storage listing = _listings[lId];
        require(msg.sender == listing.seller);
        require(listing.status == status.open);
        require(lId == find(lId));

        delete _listings[lId];
        listing.status = status.canceled;
        removeByValue(lId);
        emit deListed(msg.sender, lId);

        return (true, 'canceled');
    }

    function getAllListings() public view returns(uint[] memory) {
        return  itemsListed;
    }
}


contract Auction is IERC721 {

    event itemAuctioned(address owner, uint id, uint startPrice);
    event auctionSold(address buyer, uint id, uint sellingPrice);
    event auctionCanceled(address owner, uint id);

    uint bidTime = block.timestamp;
    uint bidEndTime;
    uint bidDuration = bidTime + bidEndTime;

}
