// SPDX-License-Identifier: MIT
pragma solidity ^0.8.9;

import "@openzeppelin/contracts/token/ERC20/ERC20.sol";
import "@openzeppelin/contracts/token/ERC20/IERC20.sol";
import "@openzeppelin/contracts/token/ERC721/IERC721.sol";
import "@openzeppelin/contracts/utils/math/SafeMath.sol";


contract Payments {
    using SafeMath for uint256;

    function buy(
        address nftContract,
        address seller,
        address currency,
        address[] memory payees,
        uint256 tokenId,
        uint256 amount
    ) internal {


        uint256 fee = (amount * 2) / 100;
        uint256 commision = amount - fee;
        uint256 payeeNumber = payees.length;
        uint256 payeeCommission = fee / payeeNumber;

        IERC721(nftContract).transferFrom(
            address(this),
            msg.sender,
            tokenId
        );
        IERC20(currency).transferFrom(msg.sender, seller, commision);
        for (uint256 receiver = 0; receiver <= payeeNumber; receiver++) {
            IERC20(currency).transferFrom(
                address(this),
                payees[receiver],
                payeeCommission
            );
        }
    }

}


contract UserLib {
    enum verified {
        yes,
        no
    }
    struct User {
    verified verified;
    address userAddress;
    uint256 regTime;
    string userURI;
    address[] ownedCollections;
    }

    mapping(address => User) users_;
    mapping(address => address[]) private ownedCollections_;

    function addNewUser(string memory useruri_) internal {
        User storage userr = users_[msg.sender];
        require(msg.sender != userr.userAddress, "Not Authorized!");
        User memory user = User(
            verified.no,
            msg.sender,
            block.timestamp,
            useruri_,
            ownedCollections_[msg.sender]
        );
        users_[msg.sender] = user;
    }

}