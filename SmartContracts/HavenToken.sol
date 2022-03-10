// SPDX-License-Identifier: MIT 

pragma solidity ^0.8.0;

import "@openzeppelin/contracts/token/ERC20/ERC20.sol";

contract HavenToken is ERC20 {
    uint256 private _totalSupply = 100000000;

    string private _name = "Haven Token";
    string private _symbol = "HVX";

    constructor() ERC20(_name, _symbol) {
        _mint(msg.sender, _totalSupply);
    }
}


contract HelloWorld {
    string public greeting = "Hello World"; // state variable


    constructor(string memory greet) { // constructor
        greeting = greet; 
    }

    function helloWorld(string memory newGreeting) public {
        greeting = newGreeting;
    }

    function newHello(string memory update) public {
        greeting = update;
    }
}
