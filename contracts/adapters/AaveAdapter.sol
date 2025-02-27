// SPDX-License-Identifier: MIT
pragma solidity 0.8.21;

import {IPool} from "@aave/core-v3/contracts/interfaces/IPool.sol";
import {DataTypes} from "@aave/core-v3/contracts/protocol/libraries/types/DataTypes.sol";
import {IAggregatorAdapter} from "../interfaces/IAggregatorAdapter.sol";
import "@openzeppelin/contracts/token/ERC20/IERC20.sol";

/// @title AaveAdapter
/// @notice Adapter for interacting with Aave V3 lending protocol.
///         This contract allows for supply, withdraw, borrow, and fetching rates from the Aave protocol.
contract AaveAdapter is IAggregatorAdapter {
    IPool public aave; // Instance of the Aave protocol interface for interacting with the lending pool

    constructor(address _aave) {
        aave = IPool(_aave); // Initialize the Aave instance to interact with the pool
    }

    function getProtocolAddress() external view override returns (address) {
        return address(aave);
    }

    function supply(address asset, uint256 amount, address onBehalfOf) external override {
        // Call Aave's supply function to deposit the specified amount of asset into the Aave pool.
        IERC20(asset).transferFrom(msg.sender, address(this), amount);
        IERC20(asset).approve(address(aave), amount);

        aave.supply(asset, amount, onBehalfOf, 0); // The '0' is the referral code (unused in this case)
    }

    function withdraw(address asset, uint256 amount, address to) external override {
        // Call Aave's withdraw function to withdraw the specified amount of asset from the pool.
        aave.withdraw(asset, amount, to); // Withdraw assets to the specified address
    }

    function borrow(address asset, uint256 amount, address onBehalfOf) external override {
        // Call Aave's borrow function to borrow the specified amount of asset from the pool.
        // '2' is the interest rate mode (stable rate mode in this case), and '0' is the referral code.
        aave.borrow(asset, amount, 2, 0, onBehalfOf); // Borrow assets with a stable rate
        IERC20(asset).transfer(msg.sender, amount);
    }

    /// @notice Get rates function to fetch the current supply and borrow rates for a given asset in Aave.
    /// @param asset The address of the asset to query the rates for (e.g., DAI).
    /// @return supplyRate The current supply interest rate for the asset.
    /// @return borrowRate The current borrow interest rate for the asset.
    function getRates(address asset) external view override returns (uint256 supplyRate, uint256 borrowRate) {
        // Fetch the ReserveData struct for the asset
        DataTypes.ReserveData memory reserveData = aave.getReserveData(asset);

        // Extract the supply and borrow rates from the ReserveData struct
        supplyRate = reserveData.liquidityIndex; // or use the field you want, e.g., reserveData.liquidityRate
        borrowRate = reserveData.currentVariableBorrowRate;

        return (supplyRate, borrowRate); // Return both supply and borrow rates
    }
}
