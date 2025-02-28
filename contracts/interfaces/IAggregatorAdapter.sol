// SPDX-License-Identifier: MIT
pragma solidity 0.8.21;

/// @title IAggregatorAdapter
/// @notice This interface defines the necessary functions for interacting with the lending protocols.
interface IAggregatorAdapter {
    /// @notice Get rates function to fetch the current supply and borrow rates for a given asset in Aave.
    /// @param asset The address of the asset to query the rates for (e.g., DAI).
    /// @return supplyRate The current supply interest rate for the asset.
    /// @return borrowRate The current borrow interest rate for the asset.
    function getRates(address asset) external view returns (uint256 supplyRate, uint256 borrowRate);

    /// @notice Supply an asset to the lending protocol.
    /// @param asset The address of the asset to deposit.
    /// @param amount The amount of the asset to deposit.
    /// @param user The address of the user depositing the asset.
    function supply(address asset, uint256 amount, address user) external;

    /// @notice Withdraw an asset from the lending protocol.
    /// @param asset The address of the asset to withdraw.
    /// @param amount The amount of the asset to withdraw.
    /// @param user The address of the user withdrawing the asset.
    function withdraw(address asset, uint256 amount, address user) external;

    /// @notice Borrow an asset from the lending protocol.
    /// @param asset The address of the asset to borrow.
    /// @param amount The amount of the asset to borrow.
    /// @param user The address of the user borrowing the asset.
    function borrow(address asset, uint256 amount, address user) external;

    /// @notice Return an address from the adapter
    function getProtocolAddress() external view returns (address);
}
