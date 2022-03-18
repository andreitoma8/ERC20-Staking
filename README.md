# ERC20Stakeable Smart Contract. 
### The goal is to create a ERC20 Stakeable library easy to implement.

Created using [OpenZeppelin](https://openzeppelin.com/) [ERC20](https://github.com/OpenZeppelin/openzeppelin-contracts/blob/master/contracts/token/ERC20/ERC20.sol) Smart Contract and [ERC20Burnable](https://github.com/OpenZeppelin/openzeppelin-contracts/blob/master/contracts/token/ERC20/extensions/ERC20Burnable.sol) extension.

### Features for users:

1. Deposit the ERC20 Token and gain a fixed APR calculated hourly.
1. Compound your rewards.
1. Claim your rewards.
1. Withdraw your deposit.
1. Withdraw all(your deposit + rewards).

### Features for owner:

1. Set a fixed APR.
1. Set a minimum stake amount.
1. Set compounding frequency limit.

### Advantages of the simple design:

- Low gas fees
- Lower room for error

### Disadvantages of the simple design:
*see else in deposti function*

- When adding funds on top of a active stake users will either:
    - Atuomatically compound their rewards
    - Have to claim their rewards and then add new tokens after

- When withdrawing a specified amount of tokens, users will also automatically withdraw their rewards


# How to use?

### Prerequisites:

- [Python](https://www.python.org/downloads/)
- Brownie
```
python3 -m pip install --user pipx
python3 -m pipx ensurepath
# restart terminal
pipx install eth-brownie
```

### Instalation 

Clone this repo:

```
git clone https://github.com/andreitoma8/ERC20-Staking
cd ERC20-Staking
```

# Deploy to Rinkeby

- Add a |.env| file with the same contents of |.env.example|, but replaced with your variables.

- Run the command:
```
brownie run scripts/deploy.py --network rinkeby
```