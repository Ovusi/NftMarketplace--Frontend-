// SPDX-License-Identifier: MIT

pragma solidity ^0.8.9;

contract App {
    /**Create an event to be emitted when a new user account
    is created. */
    event UserCreated(address newUser);

    // created a struct holding the user's account details
    struct User {
        address userAddress;
        uint256 createdTime;
        string userName;
        string email;
        string socialMediaAccounts;
    }

    // Create a mapping of address to User struct.
    mapping(address => User) users_;
    // create a list of user addresses to iterate through.
    // this is necessary
    address[] userList;

    constructor() {
        // ...
    }

    /// @dev create a new user account as soon as someone connects to your dApp.
    function createUser() public returns (string memory) {
        // Access the mapping to see if the user already exists.
        User storage user_ = users_[msg.sender];
        // require that the user does not already exist.
        require(msg.sender != user_.userAddress);
        // create a struct of the new user.
        User memory user = User(
            msg.sender,
            block.timestamp,
            "Anonymous", // place holder
            "Empty", // place holder
            "Empty" // place holder
        );

        users_[msg.sender] = user; // Add new user struct to the User mapping.
        userList.push(msg.sender); // Add the new user address to the userList array.
        emit UserCreated(msg.sender); // Emit an event alerting us of a new user created.

        return "New user created";
    }
}


/**Contract example that implements Access Control */
contract App {
    // Variable to store the address of the contract owner.
    address owner;

    // A modifier is used to alter the state of a function.
    modifier isOwner() {
        require(msg.sender == owner, "Access denied!");
        _;
    }

    constructor() {
        // When contract is deployed, it sets the address of the deployer as the owner.
        owner = msg.sender; 
    }

    /// @dev first example method of access control using "require" method.
    function edit() public {
        require(msg.sender == owner, "Access denied!");
        // ...
    }

    /// @dev second example method of access control using the "isOwner modifier".
    function editAgain() public isOwner {
        require(msg.sender == owner, "Access denied!");
        // ...
    }
}

follow @0xlegendury