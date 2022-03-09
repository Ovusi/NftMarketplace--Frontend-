// SPDX-License-Identifier: MIT 

pragma solidity ^0.8.0;

import ""

contract HavenToken is ERC20 {
    mapping(address => uint) private _balances;
    mapping(address => mapping(address => uint256)) private _allowances;

    uint256 private _totalSupply;

    string private _name;
    string private _symbol;

    constructor(string memory name_, string memory symbol_) {
        _name = name_;
        _symbol = symbol_;
        _mint(address account, )
    }


}

