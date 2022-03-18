// SPDX-License-Identifier: MIT
pragma solidity ^0.8.4;

import "@openzeppelin/contracts/token/ERC20/ERC20.sol";
import "@openzeppelin/contracts/token/ERC20/extensions/ERC20Burnable.sol";

contract ERC20Stakeable is ERC20, ERC20Burnable {
    // Staker info
    struct Staker {
        uint256 deposited;
        uint256 timeOfLastDeposit;
    }

    // Rewards per hour. A fraction calculated as x/100.000 to get the percentage
    uint256 public rewardsPerHour = 285; // 0.00285%

    // Minimum amount to stake
    uint256 public minStake = 10 * 10**decimals();

    // Compounding frequency limit in seconds
    uint256 public compoundFreq = 14400; //4 hours

    // Mapping of address
    mapping(address => Staker) internal stakers;

    constructor(string memory _name, string memory _symbol)
        ERC20(_name, _symbol)
    {}

    // If address has no stkae, initiate one. If address already was a stake,
    // compound the rewards, reset the last time of deposit and then add the deposit.
    // Burns the amount staked.
    function deposit(uint256 _amount) public {
        require(_amount >= minStake, "Amount smaller than minimimum deposit");
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

    // Compound the rewards and reset the last time of deposit
    function stakeRewards() public {
        require(stakers[msg.sender].deposited > 0, "You have no deposit");
        require(
            compoundRewardsTimer(msg.sender) == 0,
            "Tried to compound rewars too soon"
        );
        uint256 rewards = calculateRewards(msg.sender);
        require(rewards > 0, "You have no rewards");
        stakers[msg.sender].deposited += rewards;
        stakers[msg.sender].timeOfLastDeposit = block.timestamp;
    }

    // Mints rewards for msg.sender
    function claimRewards() public {
        uint256 _rewards = calculateRewards(msg.sender);
        require(_rewards > 0, "You have no rewards");
        stakers[msg.sender].timeOfLastDeposit = block.timestamp;
        _mint(msg.sender, _rewards);
    }

    // Withdraw specified amount of staked tokens + available rewards
    function withdraw(uint256 _amount) public {
        require(
            stakers[msg.sender].deposited >= _amount,
            "Can't withdraw more than you have"
        );
        uint256 _rewards = calculateRewards(msg.sender);
        stakers[msg.sender].deposited -= _amount;
        stakers[msg.sender].timeOfLastDeposit = block.timestamp;
        uint256 _withdrawBalance = _amount + _rewards;
        _mint(msg.sender, _withdrawBalance);
    }

    // Withdraw stake and rewards and mints them to the msg.sender
    function withdrawAll() public {
        require(stakers[msg.sender].deposited > 0, "You have no deposit");
        uint256 _rewards = calculateRewards(msg.sender);
        uint256 _deposit = stakers[msg.sender].deposited;
        stakers[msg.sender].deposited = 0;
        stakers[msg.sender].timeOfLastDeposit = 0;
        uint256 _amount = _rewards + _deposit;
        _mint(msg.sender, _amount);
    }

    // Function useful for fron-end that returns user stake and rewards by address
    function getDepositInfo(address _user)
        public
        view
        returns (uint256 _stake, uint256 _rewards)
    {
        _stake = stakers[_user].deposited;
        _rewards = calculateRewards(_user);
        return (_stake, _rewards);
    }

    function compoundRewardsTimer(address _user)
        public
        view
        returns (uint256 _timer)
    {
        if (
            stakers[_user].timeOfLastDeposit + compoundFreq <= block.timestamp
        ) {
            return 0;
        } else {
            return
                (stakers[_user].timeOfLastDeposit + compoundFreq) -
                block.timestamp;
        }
    }

    // Calculate the rewards a staker can claim
    function calculateRewards(address _staker)
        internal
        view
        returns (uint256 rewards)
    {
        return
            ((((block.timestamp - stakers[_staker].timeOfLastDeposit) / 3600) *
                stakers[_staker].deposited) * rewardsPerHour) / 100000;
    }
}
