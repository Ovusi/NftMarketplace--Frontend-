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

abstract contract HavenMarketPlace is
    IERC721,
    ERC721URIStorage,
    ReentrancyGuard
{
    // STATE VARIABLES
    using Counters for Counters.Counter;
    Counters.Counter private _tokenIds;

    event Listed(address seller, address newToken, uint256 id, uint256 price);
    event deListed(address owner, uint256 id);
    event Bought(address buyer, uint256 price, uint256 id);
    event Auctioned(address newToken, uint256 id, uint256 startPrice);
    event itemAuctioned(address owner, uint256 id, uint256 startPrice);
    event HighestBidIncreased(address bidder, uint256 amount);
    event auctionSold(address buyer, uint256 id, uint256 sellingPrice);
    event auctionCanceled(address owner, uint256 id);
    event withdrawnFunds(address owner, uint256 amount);

    enum status {
        open,
        sold,
        canceled,
        closed
    }

    struct Listing {
        status status;
        address seller;
        address nftContract;
        uint256 tokenId;
        uint256 price;
    }

    address payable public beneficiary;
    uint256 public bidTime = block.timestamp;
    uint256 public bidEndTime;

    address public highestBidder;
    uint256 public highestBid;

    struct AuctionedItem {
        status status;
        address creator;
        address nftContract;
        uint256 auctionTime;
        uint256 auctionEndTime;
        uint256 tokenId;
        uint256 startPrice;
    }

    Listing[] public itemsOnList; // todo
    mapping(address => mapping(uint256 => bool)) activeItems; // todo

    mapping(uint256 => Listing) public _listings;
    uint256[] public itemsListed;

    address senderAdd;
    address payable tokenContract_;

    mapping(uint256 => AuctionedItem) public auctionedItem_;
    uint256[] public itemsAuctioned;

    mapping(address => uint256) pendingReturns;

    modifier isClosed(uint256 aId) {
        AuctionedItem storage auctioneditem = auctionedItem_[aId];
        require(
            auctioneditem.status != status.open &&
                auctioneditem.status != status.canceled
        );
        require(block.timestamp > auctioneditem.auctionEndTime);

        auctioneditem.status = status.closed;
        _;
    }

    constructor(address senderAddress, address payable tokenContractAddress) {
        senderAdd = senderAddress;
        tokenContract_ = tokenContractAddress;
    }

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
    ) external nonReentrant returns (uint256) {
        IERC721(token_).transferFrom(senderAdd, address(this), tokenid_);

        Listing memory listing = Listing(
            status.open,
            senderAdd,
            token_,
            tokenid_,
            price_
        );
        _tokenIds.increment();

        uint256 newItemId = _tokenIds.current();
        _listings[newItemId] = listing;
        itemsListed.push(newItemId);

        emit Listed(senderAdd, token_, tokenid_, price_);
        return newItemId;
    }

    function buyNft(
        uint256 listingId_,
        uint256 price_,
        uint256 feePercentage
    ) external payable nonReentrant returns (bool) {
        Listing storage listing = _listings[listingId_];
        require(
            IERC20(tokenContract_).approve(address(this), price_) == true,
            "Transaction not approved."
        );
        require(
            IERC20(tokenContract_).balanceOf(senderAdd) >= price_,
            "Not enough funds."
        );
        require(senderAdd != listing.seller, "Permission not granted.");
        require(price_ >= listing.price, "Insufficient amount.");
        require(listing.status == status.open);
        require(tokenContract_ != senderAdd);
        require(tokenContract_ != listing.seller);

        uint256 fee = (price_ * feePercentage) / 100;
        uint256 commision = price_ - fee;

        IERC721(listing.nftContract).transferFrom(
            address(this),
            senderAdd,
            listing.tokenId
        );
        IERC20(tokenContract_).transferFrom(
            address(this),
            listing.seller,
            commision
        ); // Todo
        IERC20(tokenContract_).transferFrom(address(this), tokenContract_, fee); // Todo

        listing.status = status.sold;

        emit Bought(senderAdd, msg.value, listing.tokenId);

        return true;
    }

    function cancelListing(uint256 lId)
        external
        payable
        nonReentrant
        returns (bool, string memory)
    {
        Listing storage listing = _listings[lId];
        require(senderAdd == listing.seller);
        require(listing.status == status.open);
        require(lId == find(lId));

        delete _listings[lId];
        listing.status = status.canceled;
        // removeByValue(lId);
        emit deListed(senderAdd, lId);

        return (true, "canceled");
    }

    function getAllListings() public view returns (uint256[] memory) {
        return itemsListed;
    }

    function getTokenUri(uint256 lId) external view returns (string memory) {
        Listing storage listing = _listings[lId];
        return tokenURI(listing.tokenId);
    }

    function placeAuction(
        address token_,
        uint256 tokenid_,
        uint256 aucEndTime,
        uint256 price_
    ) external nonReentrant returns (uint256) {
        IERC721(token_).transferFrom(senderAdd, address(this), tokenid_);
        bidEndTime = aucEndTime;
        uint256 bidDuration = block.timestamp + bidEndTime;

        AuctionedItem memory auctionedItem = AuctionedItem(
            status.open,
            senderAdd,
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

        emit itemAuctioned(senderAdd, newItemId, price_);
        return newItemId;
    }

    function bid(
        uint256 aId,
        uint256 price_
    ) external payable nonReentrant isClosed(aId) {
        AuctionedItem storage auctioneditem = auctionedItem_[aId];
        require(
            bidTime >= auctioneditem.auctionTime &&
                bidTime <= auctioneditem.auctionEndTime,
            "Auction Ended"
        );
        require(
            price_ > auctioneditem.startPrice,
            "Bid must be greater than auction price."
        );
        require(price_ > highestBid, "Increase bid");
        require(auctioneditem.status == status.open);

        pendingReturns[highestBidder] += highestBid;

        highestBidder = senderAdd;
        highestBid = price_;

        IERC20(tokenContract_).transferFrom(senderAdd, address(this), price_);

        emit HighestBidIncreased(highestBidder, highestBid);
    }

    function withdrawUnderBid(uint256 aId)
        external
        payable
        nonReentrant
    {
        AuctionedItem storage auctioneditem = auctionedItem_[aId];
        require(senderAdd != auctioneditem.creator);
        require(senderAdd != highestBidder);

        uint256 amount = pendingReturns[senderAdd];

        IERC20(tokenContract_).transferFrom(address(this), senderAdd, amount);

        delete pendingReturns[senderAdd];
    }

    function withdrawHighestBid(
        uint256 aId,
        uint256 feePercentage
    ) external payable nonReentrant returns (bool, string memory) {
        AuctionedItem storage auctioneditem = auctionedItem_[aId];
        require(auctioneditem.status != status.canceled);
        require(block.timestamp > auctioneditem.auctionEndTime);
        require(senderAdd == auctioneditem.creator);

        uint256 amount = highestBid;

        uint256 fee = (amount * feePercentage) / 100;
        uint256 commision = amount - fee;

        IERC20(tokenContract_).transferFrom(
            address(this),
            auctioneditem.creator,
            commision
        ); // Todo
        IERC20(tokenContract_).transferFrom(address(this), tokenContract_, fee); // Todo

        emit withdrawnFunds(senderAdd, commision);

        return (true, "Withdrawal successful");
    }

    function cancelAuction(uint256 aId)
        external
        nonReentrant
        returns (bool, string memory)
    {
        AuctionedItem storage auctioneditem = auctionedItem_[aId];
        require(
            senderAdd == auctioneditem.creator,
            "You are not allowed to cancel this auction."
        );
        require(auctioneditem.status == status.open);

        IERC721(auctioneditem.nftContract).transferFrom(
            address(this),
            auctioneditem.creator,
            auctioneditem.tokenId
        );

        auctioneditem.status = status.canceled;

        emit auctionCanceled(senderAdd, aId);

        return (true, "Auction canceled");
    }

    function claimNft(uint256 aId)
        external
        payable
        nonReentrant
        isClosed(aId)
        returns (bool, string memory)
    {
        AuctionedItem storage auctioneditem = auctionedItem_[aId];
        require(senderAdd == highestBidder);
        require(block.timestamp > auctioneditem.auctionEndTime);
        require(senderAdd != auctioneditem.creator);
        require(auctioneditem.status != status.canceled);

        IERC721(auctioneditem.nftContract).transferFrom(
            address(this),
            highestBidder,
            auctioneditem.tokenId
        );

        emit auctionSold(senderAdd, aId, highestBid);

        return (true, "Reward claimed successfully.");
    }

    function getAllAuctions() external view returns (uint256[] memory) {
        return itemsAuctioned;
    }

    function getAuctionedTokenUri(uint256 aId)
        external
        view
        returns (string memory)
    {
        AuctionedItem storage auctioneditem = auctionedItem_[aId];
        return tokenURI(auctioneditem.tokenId);
    }
}
