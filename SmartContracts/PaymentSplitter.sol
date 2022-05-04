// SPDX-License-Identifier: MIT
pragma solidity ^0.8.9;

import "@openzeppelin/contracts/token/ERC20/ERC20.sol";
import "@openzeppelin/contracts/token/ERC20/IERC20.sol";
import "@openzeppelin/contracts/utils/Counters.sol";
import "@openzeppelin/contracts/token/ERC721/IERC721.sol";
import "@openzeppelin/contracts/token/ERC721/extensions/ERC721URIStorage.sol";
import "@openzeppelin/contracts/security/ReentrancyGuard.sol";

library Payments {
    address constant tokenContract_ =
        0xEeeeeEeeeEeEeeEeEeEeeEEEeeeeEeeeeeeeEEeE;
    address private constant MATIC = 0xEeeeeEeeeEeEeeEeEeEeeEEEeeeeEeeeeeeeEEeE;
    address private constant HVXTOKEN =
        0xEeeeeEeeeEeEeeEeEeEeeEEEeeeeEeeeeeeeEEeE;

    function payment(
        address nftContract,
        address seller,
        address currency,
        uint256 tokenId,
        uint256 amount,
        address[] memory payees
    ) internal {
        uint256 price_ = amount;
        uint256 fee = (price_ * 2) / 100;
        uint256 commision = price_ - fee;
        uint256 payeeNumber = payees.length;
        uint256 payeeCommission = fee / payeeNumber;

        if (currency == MATIC) {
            IERC721(nftContract).transferFrom(
                address(this),
                msg.sender,
                tokenId
            );
            IERC20(currency).transferFrom(address(this), seller, commision); // Todo
            for (uint256 receiver = 0; receiver < payees.length; receiver++) {
                IERC20(currency).transferFrom(
                    address(this),
                    payees[receiver],
                    payeeCommission
                ); // Todo
            }
        } else if (currency == HVXTOKEN) {
            IERC721(nftContract).transferFrom(
                address(this),
                msg.sender,
                tokenId
            );
            IERC20(currency).transferFrom(address(this), seller, commision); // Todo
            IERC20(tokenContract_).transferFrom(
                address(this),
                tokenContract_,
                fee
            ); // Todo
        }
    }
}
