# Flash loan

This repo is created by following the Flash loan lesson on LearnWeb3 (https://learnweb3.io/degrees/ethereum-developer-degree/senior/borrow-millions-without-collateral-from-aave-using-flash-loans/)

# Getting Started 

## Requirements

- [git](https://git-scm.com/book/en/v2/Getting-Started-Installing-Git)
  - You'll know you did it right if you can run `git --version` and you see a response like `git version x.x.x`
- [foundry](https://getfoundry.sh/)
  - You'll know you did it right if you can run `forge --version` and you see a response like `forge 0.2.0 (816e00b 2023-03-16T00:05:26.396218Z)`

## Installation

```bash
git clone https://github.com/SajidSheikh87/LW3-flash-loans-aave
cd LW3-flash-loans-aave
make
make install
```

# Testing

## Setting up environment variables

Create a .env file in the root directory of the repo. Add `ETH_MAINNET_RPC_URL` environment variable.

- `ETH_MAINNET_RPC_URL`: This is url of the Ethereum mainnet. It is used in our test when we create our own fork from the Ethereum mainnet. Please refer to the comments added inside the `test/FlashLoanExampleTest.t.sol` file for more details as to how this works. You can get setup with one for free from [Alchemy](https://alchemy.com/)

## Vanilla Foundry

```bash
foundryup
make test
```