// SPDX-License-Identifier: MIT

pragma solidity ^0.8.9;

import "@openzeppelin/contracts/token/ERC20/ERC20.sol";
import "@openzeppelin/contracts/token/ERC20/IERC20.sol";
import "@openzeppelin/contracts/utils/Counters.sol";
import "@openzeppelin/contracts/token/ERC721/IERC721.sol";
import "@openzeppelin/contracts/utils/math/Math.sol";
import "@openzeppelin/contracts/finance/PaymentSplitter.sol";

abstract contract HavenMarketPlace is IERC721 {
    using Counters for Counters.Counter;
    Counters.Counter private _tokenIds;

    event Listed(
        address newToken,
        uint id,
        uint price
    );

    event Bought(
        address buyer,
        uint price,
        uint id
    );

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

    mapping(uint256 => Listing) _listings;
    

    function listNft(
        address token_,
        uint256 tokenid_,
        uint256 price_
    ) external {
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

        emit Listed(token_, tokenid_, price_);
    }


    function buyNft(uint256 listingId_, address payable tokenContract_) external payable {
        Listing storage listing = _listings[listingId_];
        require(msg.sender != listing.seller);
        require(msg.value >= listing.price);
        require(listing.status == status.open);
        require(tokenContract_ != msg.sender);
        require(tokenContract_ != listing.seller);

        uint fee = (msg.value * 2) / 100;
        uint commision = msg.value - fee;
        
        listing.status = status.sold;

        emit Bought(msg.sender, msg.value, listing.tokenId);

        IERC721(listing.nftContract).transferFrom(address(this), msg.sender, listing.tokenId);
        payable(listing.seller).transfer(commision);
        payable(tokenContract_).transfer(fee);

    }
}
