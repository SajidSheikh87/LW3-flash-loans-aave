// SPDX-License-Identifier: MIT

pragma solidity ^0.8.24;

import {FlashLoanSimpleReceiverBase} from "aave-v3-core/contracts/flashloan/base/FlashLoanSimpleReceiverBase.sol";
import {IPoolAddressesProvider} from "aave-v3-core/contracts/interfaces/IPoolAddressesProvider.sol";
import {IERC20} from "@openzeppelin/contracts/token/ERC20/IERC20.sol";

contract FlashLoanExample is FlashLoanSimpleReceiverBase {
    /*//////////////////////////////////////////////////////////////
                                 EVENTS
    //////////////////////////////////////////////////////////////*/
    event Log(address asset, uint256 val);

    constructor(IPoolAddressesProvider provider) FlashLoanSimpleReceiverBase(provider) {}

    /*//////////////////////////////////////////////////////////////
                           EXTERNAL FUNCTIONS
    //////////////////////////////////////////////////////////////*/
    function createFlashLoan(address asset, uint256 amount) external {
        address receiver = address(this);
        bytes memory params = ""; // use this to pass arbitrary data to executeOperation
        uint16 referralCode = 0;

        POOL.flashLoanSimple(receiver, asset, amount, params, referralCode);
    }

    function executeOperation(address asset, uint256 amount, uint256 premium, address initiator, bytes calldata params)
        external
        returns (bool)
    {
        // do things like arbitrage here
        // abi.decode(params) to decode params

        uint256 amountOwing = amount + premium;
        IERC20(asset).approve(address(POOL), amountOwing);
        emit Log(asset, amountOwing);
        return true;
    }
}
