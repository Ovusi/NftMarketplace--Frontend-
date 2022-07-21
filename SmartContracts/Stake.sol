// SPDX-License-Identifier: MIT


pragma solidity ^0.8.0;

import "@openzeppelin/contracts/utils/math/SafeMath.sol";

import "SmartContracts/NFTcontract.sol";

contract HaveXStaking {
    
    function apy(uint256 principal, uint256 period) public returns (uint256) {
        uint256 div = 5/100;
        return (principal * div / 100) * period;
    }
}