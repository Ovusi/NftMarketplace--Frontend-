// SPDX-License-Identifier: MIT

pragma solidity ^0.8.0;

import "@openzeppelin/contracts/token/ERC20/ERC20.sol";
import "@openzeppelin/contracts/utils/Counters.sol";


contract HavenMarketPlace {
    using Counters for Counters.Counter;
    Counters.Counter private _tokenIds;

    enum status {open, closed}

    struct Listing {
        address nftContract;
        uint256 tokenId;
        uint256 price;
    }

    mapping(bytes32 => Listing) _listings;
    mapping(address => uint256) balances;

    function listNft(address token_, uint tokenid_, uint price_) external pure {
        Listing memory listing = Listing(
            token_,
            tokenid_,
            price_
        );
        _tokenIds.increment();

        uint newItemId = _tokenIds.current();
        _listings[newItemId] = listing; 
    }
}
