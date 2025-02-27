// SPDX-License-Identifier: MIT
pragma solidity 0.8.21;

import {IAggregatorAdapter} from "../interfaces/IAggregatorAdapter.sol";

/// @title AaveAdapter
/// @notice Adapter for interacting with Aave V3.
contract AaveAdapter is IAggregatorAdapter {
    IAaveV3 public aave;

    constructor(address _aave) {
        aave = IAaveV3(_aave);
    }

    function supply(address asset, uint256 amount, address onBehalfOf) external override {
        aave.supply(asset, amount, onBehalfOf, 0);
    }

    function withdraw(address asset, uint256 amount, address to) external override {
        aave.withdraw(asset, amount, to);
    }

    function borrow(address asset, uint256 amount, address onBehalfOf) external override {
        aave.borrow(asset, amount, 2, 0, onBehalfOf);
    }

    function getRates(address asset) external view override returns (uint256 supplyRate, uint256 borrowRate) {
        (supplyRate, borrowRate) = aave.getReserveData(asset);
    }
}
