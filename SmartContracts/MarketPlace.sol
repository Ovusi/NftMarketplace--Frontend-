// SPDX-License-Identifier: MIT

pragma solidity ^0.8.9;

import "@openzeppelin/contracts/token/ERC20/ERC20.sol";
import "@openzeppelin/contracts/token/ERC20/IERC20.sol";
import "@openzeppelin/contracts/utils/Counters.sol";
import "@openzeppelin/contracts/token/ERC721/IERC721.sol";
import "@openzeppelin/contracts/utils/math/Math.sol";
import "@openzeppelin/contracts/finance/PaymentSplitter.sol";
import "@openzeppelin/contracts/token/ERC721/extensions/ERC721URIStorage.sol";
import "@openzeppelin/contracts/security/ReentrancyGuard.sol";

abstract contract HavenMarketPlace is IERC721, ERC721URIStorage, ReentrancyGuard {

// STATE VARIABLES
    using Counters for Counters.Counter;
    Counters.Counter private _tokenIds;

    event Listed(address seller, address newToken, uint256 id, uint256 price);
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
    ) external nonReentrant() returns (uint) {
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

        emit Listed(msg.sender, token_, tokenid_, price_);
        return newItemId;
    }

    function buyNft(uint256 listingId_, address payable tokenContract_, uint price_, uint feePercentage)
        external nonReentrant()
        payable
        returns (bool)
    {
        Listing storage listing = _listings[listingId_];
        require(IERC20(tokenContract_).approve(address(this), price_) == true, "Transaction not approved.");
        require(IERC20(tokenContract_).balanceOf(msg.sender) >= price_, "Not enough funds.");
        require(msg.sender != listing.seller, "Permission not granted.");
        require(price_ >= listing.price, "Insufficient amount.");
        require(listing.status == status.open);
        require(tokenContract_ != msg.sender);
        require(tokenContract_ != listing.seller);

        uint256 fee = (price_ * feePercentage) / 100;
        uint256 commision = price_ - fee;

        IERC721(listing.nftContract).transferFrom(
            address(this),
            msg.sender,
            listing.tokenId
        );
        IERC20(tokenContract_).transferFrom(address(this), listing.seller, commision); // Todo
        IERC20(tokenContract_).transferFrom(address(this), tokenContract_, fee); // Todo

        listing.status = status.sold;

        emit Bought(msg.sender, msg.value, listing.tokenId);

        return true;
    }

    function cancelListing(uint256 lId) external nonReentrant() payable returns (bool, string memory) {
        Listing storage listing = _listings[lId];
        require(msg.sender == listing.seller);
        require(listing.status == status.open);
        require(lId == find(lId));

        delete _listings[lId];
        listing.status = status.canceled;
        // removeByValue(lId);
        emit deListed(msg.sender, lId);

        return (true, 'canceled');
    }

    function getAllListings() public view returns(uint[] memory) {
        return  itemsListed;
    }
    
    function getTokenUri(uint lId) external view returns (string memory) {
        Listing storage listing = _listings[lId];
        return tokenURI(listing.tokenId);
    }
}



// AUCTION CONTRACT...

abstract contract Auction is IERC721, ERC721URIStorage, ReentrancyGuard {

    using Counters for Counters.Counter;
    Counters.Counter private _tokenIds;

    event itemAuctioned(address owner, uint id, uint startPrice);
    event HighestBidIncreased(address bidder, uint amount);
    event auctionSold(address buyer, uint id, uint sellingPrice);
    event auctionCanceled(address owner, uint id);
    event withdrawnFunds(address owner, uint amount);

    address payable public beneficiary;
    uint public bidTime = block.timestamp;
    uint public bidEndTime;

    address public highestBidder;
    uint public highestBid;

    enum status {
        open,
        closed,
        canceled
    }

    struct AuctionedItem {
        status status;
        address creator;
        address nftContract;
        uint auctionTime;
        uint auctionEndTime;
        uint tokenId;
        uint startPrice;
    }

    mapping(uint256 => AuctionedItem) public auctionedItem_;
    uint[] public itemsAuctioned;

    mapping(address => uint) pendingReturns;

    modifier isClosed(uint aId) {
        AuctionedItem storage auctioneditem = auctionedItem_[aId];
        require(auctioneditem.status != status.open && auctioneditem.status != status.canceled);
        require(block.timestamp > auctioneditem.auctionEndTime);

        auctioneditem.status = status.closed;
        _;
    }

    function placeAuction(address token_, uint tokenid_, uint aucEndTime, uint price_) external nonReentrant() returns (uint) {
        IERC721(token_).transferFrom(msg.sender, address(this), tokenid_);
        bidEndTime = aucEndTime;
        uint bidDuration = block.timestamp + bidEndTime;

        
        AuctionedItem memory auctionedItem = AuctionedItem(
            status.open,
            msg.sender,
            token_,
            block.timestamp,
            bidDuration,
            tokenid_,
            price_
        );
        _tokenIds.increment();

        uint256 newItemId = _tokenIds.current();
        auctionedItem_[newItemId] = auctionedItem;
        itemsAuctioned.push(newItemId);

        auctionedItem.status = status.open;
        
        emit itemAuctioned(msg.sender, newItemId, price_);
        return newItemId;

    }

    function bid(uint aId, address payable tokenContract_, uint price_) external nonReentrant() isClosed(aId) payable {
        AuctionedItem storage auctioneditem = auctionedItem_[aId];
        require(bidTime >= auctioneditem.auctionTime && bidTime <= auctioneditem.auctionEndTime, "Auction Ended");
        require(price_ > auctioneditem.startPrice, "Bid must be greater than auction price.");
        require(price_ > highestBid, "Increase bid");
        require(auctioneditem.status == status.open);

        highestBidder = msg.sender;
        highestBid = price_;
        pendingReturns[highestBidder] += highestBid;

        IERC20(tokenContract_).transferFrom(msg.sender, address(this), price_);

        emit HighestBidIncreased(highestBidder, highestBid);

    }

    function withdrawUnderBid(uint aId, address payable tokenContract_) external nonReentrant() payable {  
        AuctionedItem storage auctioneditem = auctionedItem_[aId];
        require(msg.sender != auctioneditem.creator);
        require(msg.sender != highestBidder);

        uint amount = pendingReturns[msg.sender];

        IERC20(tokenContract_).transferFrom(address(this), msg.sender, amount);

        delete pendingReturns[msg.sender];

    }

    function withdrawHighestBid(uint aId, address payable tokenContract_, uint feePercentage) external nonReentrant() payable returns (bool, string memory) {
        AuctionedItem storage auctioneditem = auctionedItem_[aId];
        require(auctioneditem.status != status.canceled);
        require(block.timestamp > auctioneditem.auctionEndTime);
        require(msg.sender == auctioneditem.creator);

        uint amount = highestBid;

        uint256 fee = (amount * feePercentage) / 100;
        uint256 commision = amount - fee;

        IERC20(tokenContract_).transferFrom(address(this), auctioneditem.creator, commision); // Todo
        IERC20(tokenContract_).transferFrom(address(this), tokenContract_, fee); // Todo

        emit withdrawnFunds(msg.sender, commision);

        return (true, "Withdrawal successful");

    }

    function cancelAuction(uint aId) external nonReentrant() returns (bool, string memory) {
        AuctionedItem storage auctioneditem = auctionedItem_[aId];
        require(msg.sender == auctioneditem.creator, "You are not allowed to cancel this auction.");
        require(auctioneditem.status == status.open);

        IERC721(auctioneditem.nftContract).transferFrom(address(this), auctioneditem.creator, auctioneditem.tokenId);

        auctioneditem.status = status.canceled;

        emit auctionCanceled(msg.sender, aId);

        return (true, "Auction canceled");

    }

    function claimNft(uint aId) external nonReentrant() payable isClosed(aId) returns (bool, string memory) {
        AuctionedItem storage auctioneditem = auctionedItem_[aId];
        require(msg.sender == highestBidder);
        require(block.timestamp > auctioneditem.auctionEndTime);
        require(msg.sender != auctioneditem.creator);
        require(auctioneditem.status != status.canceled);

        IERC721(auctioneditem.nftContract).transferFrom(
            address(this),
            highestBidder,
            auctioneditem.tokenId
        );

        emit auctionSold(msg.sender, aId, highestBid);
        
        return (true, "Reward claimed successfully.");
    }

    function getAllAuctions() external view returns (uint[] memory) {
        return itemsAuctioned;
    }

    function getAuctionedTokenUri(uint aId) external view returns (string memory) {
        AuctionedItem storage auctioneditem = auctionedItem_[aId];
        return tokenURI(auctioneditem.tokenId);
    }

}
