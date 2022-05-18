// SPDX-License-Identifier: MIT

pragma solidity ^0.8.9;

import "@openzeppelin/contracts/token/ERC20/ERC20.sol";
import "@openzeppelin/contracts/token/ERC20/IERC20.sol";
import "@openzeppelin/contracts/utils/Counters.sol";
import "@openzeppelin/contracts/token/ERC721/IERC721.sol";
import "@openzeppelin/contracts/token/ERC721/extensions/ERC721URIStorage.sol";
import "@openzeppelin/contracts/security/ReentrancyGuard.sol";
import {Payments} from "../SmartContracts/PaymentSplitter.sol";
import "@openzeppelin/contracts/utils/math/SafeMath.sol";

abstract contract HavenMarketPlace is
    IERC721,
    ERC721URIStorage,
    ReentrancyGuard
{
    using Counters for Counters.Counter;
    using SafeMath for uint256;

    Counters.Counter private _tokenIds;

    /*///////////////////////////////////////////////////////////////
                            Events
    //////////////////////////////////////////////////////////////*/

    event Listed(address seller, address newToken, uint256 id, uint256 price);
    event deListed(address owner, uint256 id);
    event Bought(address buyer, uint256 price, uint256 id);
    event Auctioned(address newToken, uint256 id, uint256 startPrice);
    event itemAuctioned(address owner, uint256 id, uint256 startPrice);
    event HighestBidIncreased(address bidder, uint256 amount);
    event auctionSold(address buyer, uint256 id, uint256 sellingPrice);
    event auctionCanceled(address owner, uint256 id);
    event withdrawnFunds(address owner, uint256 amount);
    event UserCreated(address user, string useruri);
    event CollectionAdded(address user, address collectionadd);

    /*///////////////////////////////////////////////////////////////
                            State variables
    //////////////////////////////////////////////////////////////*/

    uint256 bidTime = block.timestamp;
    uint256 bidEndTime;
    uint256 highestBid;
    address payable beneficiary;
    address highestBidder;
    address senderAdd;
    address payable tokenContract_;
    address MATIC;
    address HVXTOKEN;
    address owner;
    address[] admins;
    address[] beneficiaries;

    /*///////////////////////////////////////////////////////////////
                            Enums
    //////////////////////////////////////////////////////////////*/

    enum status {
        open,
        sold,
        canceled,
        closed
    }
    enum verified {
        yes,
        no
    }

    /*///////////////////////////////////////////////////////////////
                        Structs, Mappings and Lists
    //////////////////////////////////////////////////////////////*/

    struct Listing {
        status status;
        address seller;
        address nftContract;
        address currency;
        uint256 tokenId;
        uint256 price;
    }

    struct AuctionedItem {
        status status;
        address creator;
        address nftContract;
        uint256 auctionTime;
        uint256 auctionEndTime;
        uint256 tokenId;
        uint256 startPrice;
    }

    struct User {
        verified verified;
        address userAddress;
        uint256 regTime;
        string userURI;
        address[] ownedCollections;
    }

    mapping(uint256 => Listing) public _listings;
    mapping(uint256 => AuctionedItem) public auctionedItem_;
    mapping(address => User) users_;
    mapping(address => address[]) ownedCollections_;
    mapping(address => uint256) pendingReturns;
    uint256[] owned; // arrary of NFTs owned by an address
    uint256[] public itemsListed;
    uint256[] public itemsAuctioned;
    address[] public marketUserAddresses;
    address[] public marketCollections;

    /*///////////////////////////////////////////////////////////////
                            Modifiers
    //////////////////////////////////////////////////////////////*/

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

    modifier isAdmin(address account) {
        bool isAdmin_ = false;
        for (uint256 i = 0; i < admins.length; i++) {
            if (admins[i] == account) {
                isAdmin_ = true;
            }
        }
        require(isAdmin_, "Not an Admin");
        _;
    }

    /*///////////////////////////////////////////////////////////////
                            Constructor
    //////////////////////////////////////////////////////////////*/

    constructor(address payable tokenContractAddress) {
        owner = msg.sender;
        admins.push(msg.sender);
        tokenContract_ = tokenContractAddress;
    }

    /*///////////////////////////////////////////////////////////////
                            Helper logic
    //////////////////////////////////////////////////////////////*/

    function listing_exists(uint256 id) internal view returns (bool) {
        for (uint256 i = 0; i < itemsListed.length; i++) {
            if (itemsListed[i] == id) {
                return true;
            }
        }
        return false;
    }

    function remove_listing(uint256 id) internal returns (bool) {
        for (uint256 i = 0; i < itemsListed.length; i++) {
            if (itemsListed[i] == id) {
                delete itemsListed[i];
            }
        }
        return false;
    }

    function auction_exists(uint256 id) internal view returns (bool) {
        for (uint256 i = 0; i < itemsAuctioned.length; i++) {
            if (itemsAuctioned[i] == id) {
                return true;
            }
        }
        return false;
    }

    function remove_auction(uint256 id) internal returns (bool) {
        for (uint256 i = 0; i < itemsAuctioned.length; i++) {
            if (itemsAuctioned[i] == id) {
                delete itemsAuctioned[i];
            }
        }
        return false;
    }

    /*///////////////////////////////////////////////////////////////
                            User logic
    //////////////////////////////////////////////////////////////*/

    function createUser(string memory useruri_) public returns (bool) {
        User storage userr = users_[msg.sender];
        require(msg.sender != userr.userAddress);
        User memory user = User(
            verified.no,
            msg.sender,
            block.timestamp,
            useruri_,
            ownedCollections_[msg.sender]
        );
        users_[msg.sender] = user;
        marketUserAddresses.push(msg.sender);
        emit UserCreated(msg.sender, useruri_);
        return true;
    }

    function verifiyUser(address userAccount) public isAdmin(msg.sender) {
        // todo: sort admin priviledge
        User storage user = users_[userAccount];
        require(user.verified != verified.no, "User already verified");
        require(msg.sender == owner);
        user.verified = verified.yes;
    }

    function editUser(string memory useruri_) public {
        User storage user = users_[msg.sender];
        require(msg.sender == user.userAddress);
        user.userURI = useruri_;
    }

    function add_collection(address collectionaddress)
        public
        returns (string memory)
    {
        User storage user = users_[msg.sender];
        require(msg.sender == user.userAddress);
        ownedCollections_[msg.sender].push(collectionaddress);
        user.ownedCollections = ownedCollections_[msg.sender];
        marketCollections.push(collectionaddress);

        emit CollectionAdded(msg.sender, collectionaddress);

        return "Collection added successfully";
    }

    function addAdmin(address account) public isAdmin(account) {
        require(msg.sender == owner);
        admins.push(account);
    }

    /*///////////////////////////////////////////////////////////////
                        Direct listing logic
    //////////////////////////////////////////////////////////////*/

    function listNft(
        address collectionContract,
        uint256 tokenid_,
        address currency,
        uint256 amount
    ) external nonReentrant returns (uint256) {
        require(amount > 0);
        IERC721(collectionContract).transferFrom(msg.sender, address(this), tokenid_);

        Listing memory listing = Listing(
            status.open,
            msg.sender,
            collectionContract,
            currency,
            tokenid_,
            amount
        );
        _tokenIds.increment();

        uint256 newItemId = _tokenIds.current();
        _listings[newItemId] = listing;
        itemsListed.push(newItemId);

        emit Listed(msg.sender, collectionContract, tokenid_, amount);
        return newItemId;
    }

    function buyNft(uint256 listingId_, uint256 amount)
        public
        payable
        nonReentrant
        returns (bool)
    {
        Listing storage listing = _listings[listingId_];
        require(
            IERC20(tokenContract_).approve(address(this), amount) == true,
            "Transaction not approved."
        );
        require(
            IERC20(tokenContract_).balanceOf(senderAdd) >= amount,
            "Not enough funds."
        );
        require(msg.sender != listing.seller, "Permission not granted.");
        require(amount >= listing.price, "Insufficient amount.");
        require(listing.status == status.open);
        require(tokenContract_ != msg.sender);
        require(tokenContract_ != listing.seller);

        Payments.payment(
            listing.nftContract,
            listing.seller,
            listing.currency,
            listing.tokenId,
            amount,
            beneficiaries
        );
        listing.status = status.sold;

        emit Bought(senderAdd, amount, listing.tokenId);

        return true;
    }

    function cancelListing(uint256 lId)
        public
        payable
        nonReentrant
        returns (bool, string memory)
    {
        Listing storage listing = _listings[lId];
        require(msg.sender == listing.seller);
        require(listing.status == status.open);
        require(listing_exists(lId) == true);

        IERC721(listing.nftContract).transferFrom(
            address(this),
            msg.sender,
            listing.tokenId
        );

        delete _listings[lId];
        remove_listing(lId);
        listing.status = status.canceled;
        emit deListed(senderAdd, lId);

        return (true, "canceled");
    }

    /*///////////////////////////////////////////////////////////////
                            Auction logic
    //////////////////////////////////////////////////////////////*/

    function placeAuction(
        address collectionContract,
        uint256 tokenid_,
        uint256 aucEndTime,
        uint256 amount
    ) public nonReentrant returns (uint256) {
        require(amount > 0);

        IERC721(collectionContract).transferFrom(msg.sender, address(this), tokenid_);
        bidEndTime = aucEndTime;
        uint256 bidDuration = block.timestamp + bidEndTime;

        AuctionedItem memory auctionedItem = AuctionedItem(
            status.open,
            msg.sender,
            collectionContract,
            block.timestamp,
            bidDuration,
            tokenid_,
            amount
        );
        _tokenIds.increment();

        uint256 newItemId = _tokenIds.current();
        auctionedItem_[newItemId] = auctionedItem;
        itemsAuctioned.push(newItemId);

        auctionedItem.status = status.open;

        emit itemAuctioned(msg.sender, newItemId, amount);
        return newItemId;
    }

    function bid(uint256 aId, uint256 amount)
        public
        payable
        nonReentrant
        isClosed(aId)
    {
        require(auction_exists(aId) == true);
        AuctionedItem storage auctioneditem = auctionedItem_[aId];
        require(
            bidTime >= auctioneditem.auctionTime &&
                bidTime <= auctioneditem.auctionEndTime,
            "Auction Ended"
        );
        require(
            amount > auctioneditem.startPrice,
            "Bid must be greater than auction price."
        );
        require(amount > highestBid, "Increase bid");
        require(auctioneditem.status == status.open);

        pendingReturns[highestBidder] += highestBid;

        highestBidder = msg.sender;
        highestBid = amount;

        IERC20(tokenContract_).transferFrom(msg.sender, address(this), amount);

        emit HighestBidIncreased(highestBidder, highestBid);
    }

    function withdrawUnderBid(uint256 aId) public payable nonReentrant {
        AuctionedItem storage auctioneditem = auctionedItem_[aId];
        require(msg.sender != auctioneditem.creator);
        require(msg.sender != highestBidder);

        uint256 amount = pendingReturns[msg.sender];

        IERC20(tokenContract_).transferFrom(address(this), msg.sender, amount);

        delete pendingReturns[msg.sender];
    }

    function withdrawHighestBid(uint256 aId)
        public
        payable
        nonReentrant
        returns (bool, string memory)
    {
        AuctionedItem storage auctioneditem = auctionedItem_[aId];
        require(auctioneditem.status != status.canceled);
        require(block.timestamp > auctioneditem.auctionEndTime);
        require(msg.sender == auctioneditem.creator);

        uint256 amount = highestBid;

        uint256 fee = (amount * 2) / 100;
        uint256 commision = amount - fee;

        IERC20(tokenContract_).transferFrom(
            address(this),
            auctioneditem.creator,
            commision
        ); // Todo
        IERC20(tokenContract_).transferFrom(address(this), tokenContract_, fee); // Todo

        emit withdrawnFunds(msg.sender, commision);

        return (true, "Withdrawal successful");
    }

    function cancelAuction(uint256 aId)
        public
        nonReentrant
        returns (bool, string memory)
    {
        require(auction_exists(aId) == true);
        AuctionedItem storage auctioneditem = auctionedItem_[aId];
        require(
            msg.sender == auctioneditem.creator,
            "You are not allowed to cancel this auction."
        );
        require(auctioneditem.status == status.open);

        IERC721(auctioneditem.nftContract).transferFrom(
            address(this),
            auctioneditem.creator,
            auctioneditem.tokenId
        );

        auctioneditem.status = status.canceled;
        remove_auction(aId);

        emit auctionCanceled(msg.sender, aId);

        return (true, "Auction canceled");
    }

    function claimNft(uint256 aId)
        public
        payable
        nonReentrant
        isClosed(aId)
        returns (bool, string memory)
    {
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

    /*///////////////////////////////////////////////////////////////
                            Getter functions
    //////////////////////////////////////////////////////////////*/

    function getAllAuctions() public view returns (uint256[] memory) {
        return itemsAuctioned;
    }

    function getAuctionedTokenUri(uint256 aId)
        public
        view
        returns (string memory)
    {
        require(auction_exists(aId) == true);
        AuctionedItem storage auctioneditem = auctionedItem_[aId];
        return tokenURI(auctioneditem.tokenId);
    }

    function getListingById(uint256 lId)
        public
        view
        returns (Listing memory)
    {
        require(listing_exists(lId) == true);
        Listing storage listing = _listings[lId];
        return listing;
    }

    function getAllListings() public view returns (uint256[] memory) {
        return itemsListed;
    }

    function getTokenUri(uint256 lId) public view returns (string memory) {
        Listing storage listing = _listings[lId];
        return tokenURI(listing.tokenId);
    }

    function isVerified(address userAccount) public view returns (bool) {
        User storage user = users_[userAccount];
        if (user.verified == verified.yes) {
            return true;
        }
        return false;
    }
}
