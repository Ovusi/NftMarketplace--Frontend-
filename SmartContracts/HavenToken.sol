// SPDX-License-Identifier: MIT

pragma solidity ^0.8.0;

import "@openzeppelin/contracts/token/ERC20/ERC20.sol";

contract HavenToken is ERC20 {
    uint256 private _totalSupply = 100000000 * 10**decimals();

    string private _name = "Haven Token";
    string private _symbol = "HVX";

    constructor() ERC20(_name, _symbol) {
        _mint(msg.sender, _totalSupply);
    }
}
