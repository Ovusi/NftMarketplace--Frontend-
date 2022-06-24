// SPDX-License-Identifier: MIT


pragma solidity ^0.8.9;


import "SmartContracts/NFTcontract.sol";

contract New {
    
    function chaN() public returns (bool) {
        NFT.changeName(newName);
        return true;
    }
}