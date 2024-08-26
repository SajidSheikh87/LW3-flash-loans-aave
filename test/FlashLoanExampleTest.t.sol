// SPDX-License-Identifier: MIT

pragma solidity ^0.8.24;

import {Test, console2} from "forge-std/Test.sol";
import {FlashLoanExample} from "../src/FlashLoanExample.sol";
import {IERC20} from "@openzeppelin/contracts/token/ERC20/IERC20.sol";
import {IPoolAddressesProvider} from "aave-v3-core/contracts/interfaces/IPoolAddressesProvider.sol";

contract FlashLoanExampleTest is Test {
    // Ethereum Mainnet DAI contract address from https://docs.aave.com/developers/deployed-contracts/v3-mainnet/polygon

    address constant DAI = 0x6B175474E89094C44Da98b954EedeAC495271d0F;

    // Mainnet Pool contract address from https://docs.aave.com/developers/deployed-contracts/v3-mainnet/polygon
    address constant POOL_ADDRESS_PROVIDER = 0x2f39d218133AFaB8F2B819B1066c7E434Ad94E9e;

    // vm.envString is provided by Foundry so that we can read our .env file and get values from there
    string MAINNET_RPC_URL = vm.envString("ETH_MAINNET_RPC_URL");

    uint256 mainnetFork;
    IERC20 public token;

    FlashLoanExample flashLoanExample;

    function setUp() public {
        // vm is a variable included in the forge stadard librarry that is used to manipulate the execution environment of our tests
        // create a fork of Ethereum mainnet using the specified RPC URL and store its id in mainnetFork
        mainnetFork = vm.createFork(MAINNET_RPC_URL);
        // select the fork thus obtained, using its id
        vm.selectFork(mainnetFork);
        // deploy FlashLoanExample to the created fork with POOL_ADDRESS_PROVIDER as its constructor argument
        flashLoanExample = new FlashLoanExample(IPoolAddressesProvider(POOL_ADDRESS_PROVIDER));

        //fetch the DAI contract
        token = IERC20(DAI);
    }

    function testTakeAndReturnLoadn() public {
        // Get 2000 DAI in our contract by using deal
        // deal is a cheatcode that lets us arrbitrarily set the balance of any address and works with most ERC-20 tokens
        uint256 BALANCE_AMOUNT_DAI = 2000 ether;
        deal(DAI, address(flashLoanExample), BALANCE_AMOUNT_DAI);

        // Request and execute a flash loan of 10,000 DAI from Aave
        flashLoanExample.createFlashLoan(DAI, 10000);

        // By this point, we should have executed the flash loan and paid back (10,000 + premium) DAI to Aave
        // Let's check our contract's remaining DAI balance to see how much it has left
        uint256 remainingBalance = token.balanceOf(address(flashLoanExample));
        console2.log("Remaining balance of FlashLoanExample Contract: ", remainingBalance);

        // Our remaining balance should be <2000 DAI we originally had, because we had to pay the premium
        // AssertLt => assert stringtly less than
        assertLt(remainingBalance, BALANCE_AMOUNT_DAI);
    }
}
