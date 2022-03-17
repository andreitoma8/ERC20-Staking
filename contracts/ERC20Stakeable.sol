// SPDX-License-Identifier: MIT
pragma solidity ^0.8.4;

import "@openzeppelin/contracts/token/ERC20/ERC20.sol";
import "@openzeppelin/contracts/token/ERC20/extensions/ERC20Burnable.sol";
import "@openzeppelin/contracts/access/Ownable.sol";

contract StakeableToken is ERC20, ERC20Burnable, Ownable {
    struct Staker {
        uint256 deposited;
        uint256 timeOfLastDeposit;
    }

    uint256 public rewardsPerHour = 285; // 0.00285%

    mapping(address => Staker) internal stakers;

    constructor() ERC20("StakeableToken", "STK") {}

    function mint(address to, uint256 amount) public onlyOwner {
        _mint(to, amount);
    }

    // If staker already was a deposit, the rewards will also be staked on another deposit
    function deposit(uint256 _amount) public {
        require(_amount > 0, "Can't stake nothing");
        require(
            balanceOf(msg.sender) >= _amount,
            "Can't stake more than you own"
        );
        if (stakers[msg.sender].deposited == 0) {
            stakers[msg.sender].deposited = _amount;
            stakers[msg.sender].timeOfLastDeposit = block.timestamp;
        } else {
            uint256 rewards = calculateRewards(msg.sender);
            stakers[msg.sender].deposited += (rewards + _amount);
            stakers[msg.sender].timeOfLastDeposit = block.timestamp;
        }
        _burn(msg.sender, _amount);
    }

    function stakeRewards() public {
        require(stakers[msg.sender].deposited > 0, "You have no deposit");
        uint256 rewards = calculateRewards(msg.sender);
        require(rewards > 0, "you have no rewards");
        stakers[msg.sender].deposited += rewards;
        stakers[msg.sender].timeOfLastDeposit = block.timestamp;
    }

    function _stakeRewards(address _staker) internal {}

    function calculateRewards(address _staker)
        public
        view
        returns (uint256 rewards)
    {
        return
            ((((block.timestamp - stakers[_staker].timeOfLastDeposit) / 3600) *
                stakers[_staker].deposited) * rewardsPerHour) / 100000;
    }

    function withdrawAll() public {
        _mint(msg.sender, 1);
    }

    function withdrawRewards() public {
        _mint(msg.sender, 1);
    }

    function getDepositInfo() public view returns (uint256 _stake) {}
}
