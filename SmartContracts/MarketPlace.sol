// SPDX-License-Identifier: MIT

pragma solidity ^0.8.9;

import "@openzeppelin/contracts/token/ERC20/IERC20.sol";
import "@openzeppelin/contracts/utils/Counters.sol";
import "@openzeppelin/contracts/token/ERC721/IERC721.sol";
import "@openzeppelin/contracts/token/ERC721/extensions/ERC721URIStorage.sol";
import "@openzeppelin/contracts/security/ReentrancyGuard.sol";
import {Payments, UserLib} from "../SmartContracts/libs.sol";
import "@openzeppelin/contracts/utils/math/SafeMath.sol";

contract HavenMarketPlace is
    IERC721,
    ERC721URIStorage,
    ReentrancyGuard,
    Payments,
    UserLib
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

    uint256 private bidTime = block.timestamp;
    uint256 private bidEndTime;
    uint256 private highestBid;
    address private beneficiary;
    address private highestBidder;
    address private senderAdd;
    address private tokenContract_;
    address private MATIC;
    address private HVXTOKEN;
    address private owner_;
    address[] private  admins;
    address[] private beneficiaries;

    /*///////////////////////////////////////////////////////////////
                            Enums
    //////////////////////////////////////////////////////////////*/

    enum status {
        open,
        sold,
        canceled,
        closed
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


    mapping(uint256 => Listing) private _listings;
    mapping(uint256 => AuctionedItem) private auctionedItem_;
    mapping(address => address[]) private ownedCollections_;
    mapping(address => uint256) private pendingReturns;
    uint256[] owned; // arrary of NFTs owned by an address
    uint256[] private itemsListed;
    uint256[] private itemsAuctioned;
    address[] private marketUserAddresses;
    address[] private marketCollections;

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

    modifier isAdmin() {
        bool isAdmin_ = false;
        for (uint256 i = 0; i < admins.length; i++) {
            if (admins[i] == msg.sender) {
                isAdmin_ = true;
            }
        }
        require(isAdmin_);
        _;
    }

    /*///////////////////////////////////////////////////////////////
                            Constructor
    //////////////////////////////////////////////////////////////*/

    constructor(address tokenContractAddress) ERC721("HavenX", "HVX") {
        owner_ = msg.sender;
        admins.push(msg.sender);
        tokenContract_ = tokenContractAddress;
    }

    /*///////////////////////////////////////////////////////////////
                            Helper logic
    //////////////////////////////////////////////////////////////*/


    /// @dev Check if a listing exists by Id.
    function listing_exists(uint256 id) internal view returns (bool) {
        for (uint256 i = 0; i < itemsListed.length; i++) {
            if (itemsListed[i] == id) {
                return true;
            }
        }
        return false;
    }

    /// @dev Check if Auctioned item exists by Id.
    function auction_exists(uint256 id) internal view returns (bool) {
        for (uint256 i = 0; i < itemsAuctioned.length; i++) {
            if (itemsAuctioned[i] == id) {
                return true;
            }
        }
        return false;
    }

    /*///////////////////////////////////////////////////////////////
                            User logic
    //////////////////////////////////////////////////////////////*/

    /// @dev Creates a new user if user does not already exist.
    function createUser(string memory useruri_) public {
        return UserLib.addNewUser(useruri_);
    }

    /// @dev Mark a user verified after KYC. can also unverify user.
    function verifiyUser(address userAccount)
        public
        isAdmin
        returns (string memory)
    {
        User storage user = users_[userAccount];
        require(msg.sender == owner_);

        if (user.verified == verified.no) {
            user.verified = verified.yes;
            return "Successfully verified";
        }

        if (user.verified == verified.yes) {
            user.verified = verified.no;
            return "Successfully unverified";
        }
    }

    /// @dev Enable existing user edit account info.
    function editUser(string memory useruri_) public {
        User storage user = users_[msg.sender];
        require(msg.sender == user.userAddress);
        user.userURI = useruri_;
    }

    /// @dev Enable user to add a new collection.
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

    function addAdmin(address account) public isAdmin {
        require(msg.sender == owner_);
        admins.push(account);
    }

    /*///////////////////////////////////////////////////////////////
                        Direct listing logic
    //////////////////////////////////////////////////////////////*/

    /// @dev List an NFT on the marketplace.
    function listNft(
        address collectionContract,
        uint256 tokenid_,
        address currency,
        uint256 amount
    ) external payable nonReentrant returns (uint256) {
        User storage user = users_[msg.sender];
        require(msg.sender == user.userAddress);
        require(amount > 0);
        IERC721(collectionContract).transferFrom(
            msg.sender,
            address(this),
            tokenid_
        );

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

    /// @dev Allows a user purchase an direct listing.
    function buyNft(uint256 listingId_, uint256 amount, address currency)
        public
        payable
        nonReentrant
        returns (bool)
    {
        Listing storage listing = _listings[listingId_];
        User storage user = users_[msg.sender];
        require(msg.sender == user.userAddress);
        require(
            IERC20(tokenContract_).approve(address(this), amount) == true
        );
        require(
            IERC20(tokenContract_).balanceOf(senderAdd) >= amount
        );
        require(msg.sender != listing.seller);
        require(amount >= listing.price);
        require(listing.status == status.open);
        require(tokenContract_ != msg.sender);
        require(tokenContract_ != listing.seller);
        require(currency == listing.currency);

        Payments.buy(
            listing.nftContract,
            listing.seller,
            currency,
            beneficiaries,
            listing.tokenId,
            amount
        );
        listing.status = status.sold;

        emit Bought(senderAdd, amount, listing.tokenId);

        return true;
    }

    /// @dev Enables the owner of a direct listing to cancel the Listing.
    function cancelListing(uint256 lId)
        public
        payable
        nonReentrant
        returns (bool)
    {
        Listing storage listing = _listings[lId];
        User storage user = users_[msg.sender];
        require(msg.sender == user.userAddress);
        require(msg.sender == listing.seller);
        require(listing.status == status.open);
        require(listing_exists(lId) == true);

        IERC721(listing.nftContract).transferFrom(
            address(this),
            msg.sender,
            listing.tokenId
        );

        delete _listings[lId];
        listing.status = status.canceled;
        emit deListed(senderAdd, lId);

        return true;
    }

    /*///////////////////////////////////////////////////////////////
                            Auction logic
    //////////////////////////////////////////////////////////////*/

    /// @dev Create an auction.
    function placeAuction(
        address collectionContract,
        uint256 tokenid_,
        uint256 aucEndTime,
        uint256 amount
    ) public nonReentrant returns (uint256) {
        User storage user = users_[msg.sender];
        require(msg.sender == user.userAddress);
        require(amount > 0);

        IERC721(collectionContract).transferFrom(
            msg.sender,
            address(this),
            tokenid_
        );
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

    /// @dev Place a bid on an auctioned item.
    function bid(uint256 aId, uint256 amount)
        public
        payable
        nonReentrant
        isClosed(aId)
    {
        User storage user = users_[msg.sender];
        require(msg.sender == user.userAddress);
        require(auction_exists(aId) == true);
        AuctionedItem storage auctioneditem = auctionedItem_[aId];
        require(
            bidTime >= auctioneditem.auctionTime &&
                bidTime <= auctioneditem.auctionEndTime
        );
        require(
            amount > auctioneditem.startPrice
        );
        require(amount > highestBid);
        require(auctioneditem.status == status.open);

        pendingReturns[highestBidder] += highestBid;

        highestBidder = msg.sender;
        highestBid = amount;

        IERC20(tokenContract_).transferFrom(msg.sender, address(this), amount);

        emit HighestBidIncreased(highestBidder, highestBid);
    }

    /// @dev Allow a bidder withdraw a bid if it has been outbid.
    function withdrawUnderBid(uint256 aId) public payable nonReentrant {
        AuctionedItem storage auctioneditem = auctionedItem_[aId];
        require(msg.sender != auctioneditem.creator);
        require(msg.sender != highestBidder);

        uint256 amount = pendingReturns[msg.sender];

        IERC20(tokenContract_).transferFrom(address(this), msg.sender, amount);

        delete pendingReturns[msg.sender];
    }

    /// @dev Allow auction owner withdraw the wiining bid after auction closes.
    function withdrawHighestBid(uint256 aId)
        public
        payable
        nonReentrant
        returns (bool)
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

        return true;
    }

    /// @dev Allow auction owner cancel an auction.
    function cancelAuction(uint256 aId)
        public
        nonReentrant
        returns (bool)
    {
        require(auction_exists(aId) == true);
        AuctionedItem storage auctioneditem = auctionedItem_[aId];
        require(
            msg.sender == auctioneditem.creator
        );
        require(auctioneditem.status == status.open);

        IERC721(auctioneditem.nftContract).transferFrom(
            address(this),
            auctioneditem.creator,
            auctioneditem.tokenId
        );

        auctioneditem.status = status.canceled;

        emit auctionCanceled(msg.sender, aId);

        return true;
    }

    /// @dev Allow auction winner claim the reward.
    function claimNft(uint256 aId)
        public
        payable
        nonReentrant
        isClosed(aId)
        returns (bool)
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

        return true;
    }

    /*///////////////////////////////////////////////////////////////
                            Getter functions
    //////////////////////////////////////////////////////////////*/

    /// @dev Get all auctioned items in an array.
    function getAllAuctions() public view returns (uint256[] memory) {
        return itemsAuctioned;
    }

    /// @dev Returns the URI of an auctioned token by Id.
    function getAuctionedTokenUri(uint256 aId)
        public
        view
        returns (string memory)
    {
        require(auction_exists(aId) == true);
        AuctionedItem storage auctioneditem = auctionedItem_[aId];
        return tokenURI(auctioneditem.tokenId);
    }

    /// @dev Returns a direct listing by Id.
    function getListingById(uint256 lId) public view returns (Listing memory) {
        require(listing_exists(lId) == true);
        Listing storage listing = _listings[lId];
        return listing;
    }

    /// @dev Get all direct listings in an array.
    function getAllListings() public view returns (uint256[] memory) {
        return itemsListed;
    }

    /// @dev Returns the URI of a direct listing by Id.
    function getTokenUri(uint256 lId) public view returns (string memory) {
        Listing storage listing = _listings[lId];
        return tokenURI(listing.tokenId);
    }

    /// @dev Checks if user is verified.
    function isVerified(address userAccount) public view returns (bool) {
        User storage user = users_[userAccount];
        if (user.verified == verified.yes) {
            return true;
        }
        return false;
    }
}
