// SPDX-License-Identifier: MIT
pragma solidity 0.8.21;

import {IAggregatorAdapter} from "../interfaces/IAggregatorAdapter.sol";
import {ICompoundV3} from "../interfaces/ICompoundV3.sol";
import "@openzeppelin/contracts/token/ERC20/IERC20.sol";

/// @title CompoundAdapter
/// @notice Adapter for interacting with Compound V3 lending protocol.
contract CompoundAdapter is IAggregatorAdapter {
    ICompoundV3 public compound;

    /// @notice Constructor to initialize the Compound adapter with a specific Compound contract address.
    /// @param _compound The address of the Compound V3 contract to interact with.
    constructor(address _compound) {
        compound = ICompoundV3(_compound); // Initialize the Compound instance
    }

    function getProtocolAddress() external view override returns (address) {
        return address(compound);
    }

    /// @notice Supply function to deposit assets into the Compound protocol.
    /// @param asset The address of the asset being supplied (e.g., DAI).
    /// @param amount The amount of the asset to supply.
    /// @param onBehalfOf The address on behalf of whom the supply is made (can be a different address).
    function supply(address asset, uint256 amount, address onBehalfOf) external override {
        compound.mint(asset, amount); // Deposit the specified amount of asset into Compound
    }

    /// @notice Withdraw function to redeem assets from the Compound protocol.
    /// @param asset The address of the asset being withdrawn (e.g., DAI).
    /// @param amount The amount of the asset to redeem.
    /// @param to The address where the redeemed assets will be sent.
    function withdraw(address asset, uint256 amount, address to) external override {
        compound.redeem(asset, amount); // Redeem the specified amount of asset from Compound
        IERC20(asset).transfer(to, amount);
    }

    /// @notice Borrow function to borrow assets from the Compound protocol.
    /// @param asset The address of the asset to borrow (e.g., DAI).
    /// @param amount The amount of the asset to borrow.
    /// @param onBehalfOf The address on behalf of whom the borrowing is done (can be a different address).
    function borrow(address asset, uint256 amount, address onBehalfOf) external override {
        compound.borrow(asset, amount); // Borrow the specified amount of asset from Compound
        IERC20(asset).transfer(msg.sender, amount);
    }

    /// @notice Get rates function to fetch the current borrow rate for a given asset in Compound.
    /// @param asset The address of the asset to query the borrow rate for (e.g., DAI).
    /// @return supplyRate The current supply interest rate for the asset.
    /// @return borrowRate The current borrow interest rate for the asset.
    function getRates(address asset) external view override returns (uint256 supplyRate, uint256 borrowRate) {
        borrowRate = compound.getBorrowRate(asset); // Fetch the borrow rate for the specified asset
        return (borrowRate, borrowRate); // Return the same rate for both supply and borrow as an example
    }
}
