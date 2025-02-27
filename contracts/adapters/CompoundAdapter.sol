// SPDX-License-Identifier: MIT
pragma solidity 0.8.21;

import {IAggregatorAdapter} from "../interfaces/IAggregatorAdapter.sol";

/// @title CompoundAdapter
/// @notice Adapter for interacting with Compound V3.
contract CompoundAdapter is IAggregatorAdapter {
    ICompoundV3 public compound;

    constructor(address _compound) {
        compound = ICompoundV3(_compound);
    }

    function supply(address asset, uint256 amount, address onBehalfOf) external override {
        compound.supply(asset, amount);
    }

    function withdraw(address asset, uint256 amount, address to) external override {
        compound.withdraw(asset, amount);
    }

    function borrow(address asset, uint256 amount, address onBehalfOf) external override {
        compound.borrow(asset, amount);
    }

    function getRates(address asset) external view override returns (uint256 supplyRate, uint256 borrowRate) {
        uint256 borrowRate = compound.getBorrowRate(asset);
        return (borrowRate, borrowRate);
    }
}
