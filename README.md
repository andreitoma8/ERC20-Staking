# ERC20Stakeable Smart Contract.
### The goal is to create a ERC20 Stakeable library easy to implement for any token.
### This Smart Contract is not Audited!

Created using [OpenZeppelin](https://openzeppelin.com/) [ERC20](https://github.com/OpenZeppelin/openzeppelin-contracts/blob/master/contracts/token/ERC20/ERC20.sol) Smart Contract and [ERC20Burnable](https://github.com/OpenZeppelin/openzeppelin-contracts/blob/master/contracts/token/ERC20/extensions/ERC20Burnable.sol) extension.

Inspired by [Patrick Collins'](https://github.com/PatrickAlphaC) [DeFi-minimal Staking.sol](https://github.com/smartcontractkit/defi-minimal/blob/main/contracts/Staking.sol).

### Features for users:

1. Deposit the ERC20 Token and gain a fixed APR calculated hourly.
1. Compound your rewards.
1. Claim your rewards.
1. Withdraw a part of deposit.
1. Withdraw all(your deposit + rewards).

### Features for owner:

1. Set a fixed APR.
1. Set a minimum stake amount.
1. Set compounding frequency limit.

# How to use?

### Prerequisites:

##### Rinkeby deployment
- [Python](https://www.python.org/downloads/)
- Brownie
```
python3 -m pip install --user pipx
python3 -m pipx ensurepath
# restart terminal
pipx install eth-brownie
```
- A free [Infura](https://infura.io/) Project Id key for Rinkeby Network

### Instalation 

Clone this repo:

```
git clone https://github.com/andreitoma8/ERC20-Staking
cd ERC20-Staking
```

### Deploy to Rinkeby

- Add a `.env` file with the same contents of `.env.example`, but replaced with your variables.

- Run the command:
```
brownie run scripts/deploy.py --network rinkeby
```
The script will deploy the token, mint 1.000.000 for yourself and verify the Smart Contract on .rinkeby.etherscan.io


##### Any feedback is much apreciated! 
##### If this was helpful please consider donating: 
`0xA4Ad17ef801Fa4bD44b758E5Ae8B2169f59B666F`

### Run test locally on Ganache

##### For unning local tests you also need: 
- [Ganache CLI](https://www.npmjs.com/package/ganache-cli)
```
npm install -g ganache-cli
```
or, if you are using Yarn
```
yarn global add ganache-cli
```
- [NodeJS](https://nodejs.org/en/).
To verify NodeJS installation run
```
node --version
```

##### Test scripts

- Run the command:
```
brownie test testes/test.py
```

The test will assert the following:
1. Contract deployment
1. Initial staking transaction
1. Rewards calculation in 100 H
1. Compound rewards transaction
1. Withdraw rewards transaction
1. Withdraw all transaction

# Happy hacking!