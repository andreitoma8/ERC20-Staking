// SPDX-License-Identifier: MIT
pragma solidity ^0.8.4;

import "./ERC20Stakeable.sol";

contract MyStakeableToken is ERC20Stakeable {
    constructor(string memory _name, string memory _symbol)
        ERC20Stakeable(_name, _symbol)
    {
        _mint(msg.sender, 1000000);
    }
}
