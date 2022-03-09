// SPDX-License-Identifier: MIT

pragma solidity ^0.8.0;

import "@openzeppelin/contracts/token/ERC20/ERC20.sol";

contract HavenMarketPlace {
    struct listing {
        address offerer;
        address hostContract;
        uint256 tokenId;
        uint256 price;
        bool closed;
    }

    mapping(bytes32 => listing) offeringRegistry;
    mapping(address => uint256) balances;

    constructor(address _operator) {
        _operator;
    }
}
