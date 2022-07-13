// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import "@openzeppelin/contracts/token/ERC20/ERC20.sol";
import "@openzeppelin/contracts/token/ERC20/IERC20.sol";
import "@openzeppelin/contracts/token/ERC721/IERC721.sol";
import "@openzeppelin/contracts/utils/math/SafeMath.sol";


library Payments {
    using SafeMath for uint256;

    address constant tokenContract_ =
        0xEeeeeEeeeEeEeeEeEeEeeEEEeeeeEeeeeeeeEEeE;
    address private constant MATIC = 0xEeeeeEeeeEeEeeEeEeEeeEEEeeeeEeeeeeeeEEeE;
    address private constant HVXTOKEN =
        0xEeeeeEeeeEeEeeEeEeEeeEEEeeeeEeeeeeeeEEeE;
        

    function payment(
        address nftContract,
        address currency,
        uint256 tokenId,
        uint256 amount
    ) internal {
        if (currency == MATIC || currency == HVXTOKEN) {
            IERC721(nftContract).transferFrom(
                address(this),
                msg.sender,
                tokenId
            );
            IERC20(currency).transferFrom(msg.sender, address(this), amount); // Todo

        } else {
            revert();
        }
    }
}