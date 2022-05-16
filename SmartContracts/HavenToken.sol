// SPDX-License-Identifier: MIT

pragma solidity ^0.8.0;

import "@openzeppelin/contracts/token/ERC20/ERC20.sol";

contract HavenToken is ERC20 {
    uint256 private stakeAllocation = 10000000;
    uint256 private maxSupply = 100000000;
    uint256 private initialMintSupply = 90000000;

    string private _name = "Haven Token";
    string private _symbol = "HVX";

    constructor() ERC20(_name, _symbol) {
        _mint(msg.sender, initialMintSupply * 10**decimals());
    }
}
