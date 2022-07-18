// SPDX-License-Identifier: MIT

pragma solidity ^0.8.0;

import "@openzeppelin/contracts/token/ERC20/ERC20.sol";

contract HavenToken is ERC20 {
    uint256 private rewardSupply = 100000000 * 10**9;
    uint256 private initialMintSupply = 90000000 * 10**decimals();
    uint256 totalRewarded;

    address marketplace = 0xEeeeeEeeeEeEeeEeEeEeeEEEeeeeEeeeeeeeEEeE;
    address stakingAddress = 0xEeeeeEeeeEeEeeEeEeEeeEEEeeeeEeeeeeeeEEeE;
    address owner;

    string private _name = "Haven Token";
    string private _symbol = "HVX";

    constructor() ERC20(_name, _symbol) {
        owner = msg.sender;
        _mint(msg.sender, initialMintSupply);
    }

    function marketplaceRewards(address account, uint256 amount) external {
        uint256 floatReward = (amount * 10) ^ 0;

        require(msg.sender == marketplace || msg.sender == stakingAddress);
        require(totalRewarded < rewardSupply);
        require(floatReward < rewardSupply);

        _mint(account, amount);

        totalRewarded += floatReward;
    }

    function setMarketAddress(address marketAddress) external {
        require(msg.sender == owner);

        marketplace = marketAddress;
    }

    function setStakingAddress(address stakingContractAddress) external {
        require(msg.sender == owner);

        stakingAddress = stakingContractAddress;
    }
    
    function marketContract() external view returns (address) {
        return marketplace;
    }

    function stakingContract() external view returns (address) {
        return stakingAddress;
    }
}
