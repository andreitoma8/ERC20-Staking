// SPDX-License-Identifier: MIT
pragma solidity ^0.8.4;

import "@openzeppelin/contracts/token/ERC20/ERC20.sol";
import "@openzeppelin/contracts/token/ERC20/extensions/ERC20Burnable.sol";
import "@openzeppelin/contracts/access/Ownable.sol";

contract ERC20Stakeable is ERC20, ERC20Burnable, Ownable {
    struct Staker {
        uint256 deposited;
        uint256 timeOfLastDeposit;
    }

    uint256 public rewardsPerHour = 285; // 0.00285%

    mapping(address => Staker) internal stakers;

    constructor(string memory _name, string memory _symbol)
        ERC20(_name, _symbol)
    {}

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

    // function _stakeRewards(address _staker) internal {
    //     require(stakers[_staker].deposited > 0, "You have no deposit");
    //     uint256 rewards = calculateRewards(msg.sender);
    //     require(rewards > 0, "you have no rewards");
    //     stakers[_staker].deposited += rewards;
    //     stakers[_stake].timeOfLastDeposit=block.timestamp;
    // }

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
        require(stakers[msg.sender].deposited > 0, "You have no deposit");
        uint256 _rewards = calculateRewards(msg.sender);
        uint256 _deposit = stakers[msg.sender].deposited;
        stakers[msg.sender].deposited = 0;
        stakers[msg.sender].timeOfLastDeposit = 0;
        uint256 _amount = _rewards + _deposit;
        _mint(msg.sender, _amount);
    }

    function withdrawRewards() public {
        uint256 _rewards = calculateRewards(msg.sender);
        require(_rewards > 0, "You have no rewards");
        _mint(msg.sender, _rewards);
    }

    function getDepositInfo(address _user)
        public
        view
        returns (uint256 _stake, uint256 _rewards)
    {
        _stake = stakers[_user].deposited;
        _rewards = calculateRewards(_user);
        return (_stake, _rewards);
    }
}
