// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import "@openzeppelin/contracts/token/ERC20/ERC20.sol";

contract MockERC20 is ERC20 {

    // Constructor to initialize the token with a name and symbol, and initial supply
    constructor() ERC20("MockERC20", "MOK") {
        _mint(msg.sender, type(uint128).max);
    }

    // Function to mint new tokens (can only be called by the owner or admin)
    function mint(address to, uint256 amount) public {
        _mint(to, amount);
    }

    // Function to burn tokens (can only be called by the owner or admin)
    function burn(address from, uint256 amount) public {
        _burn(from, amount);
    }

    
}
