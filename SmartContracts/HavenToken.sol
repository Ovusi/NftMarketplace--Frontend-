// SPDX-License-Identifier: MIT

pragma solidity ^0.8.0;

import "@openzeppelin/contracts/token/ERC20/ERC20.sol";

contract HavenToken is ERC20 {
    uint256 private maxSupply = 100000000 * 10**9;
    uint256 private initialMintSupply = 90000000 * 10**decimals();
    uint8 _decimals;

    address marketplace = 0xEeeeeEeeeEeEeeEeEeEeeEEEeeeeEeeeeeeeEEeE;
    address stakingAddress = 0xEeeeeEeeeEeEeeEeEeEeeEEEeeeeEeeeeeeeEEeE;

    string private _name = "Haven Token";
    string private _symbol = "HVX";

    constructor() ERC20(_name, _symbol) {
        _mint(msg.sender, initialMintSupply);
    }

    function marketplaceRewards(address account, uint256 amount) external {
        require(msg.sender == marketplace || msg.sender == stakingAddress);
        _mint(account, amount);
    }
}
