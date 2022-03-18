// SPDX-License-Identifier: MIT
pragma solidity ^0.8.4;

import "./ERC20Stakeable.sol";

contract MyToken is ERC20Stakeable {
    constructor(string memory _name, string memory _symbol)
        ERC20Stakeable(_name, _symbol)
    {
        _mint(1000000, msg.sender);
    }
}
