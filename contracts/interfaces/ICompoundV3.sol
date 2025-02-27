// SPDX-License-Identifier: MIT
pragma solidity 0.8.21;

interface ICompoundV3 {
    /// @notice Supply function for depositing assets into the Compound protocol.
    /// @param asset The address of the asset being supplied (e.g., DAI).
    /// @param amount The amount of the asset to supply.
    function mint(address asset, uint256 amount) external;

    /// @notice Withdraw function for redeeming assets from the Compound protocol.
    /// @param asset The address of the asset being withdrawn (e.g., DAI).
    /// @param amount The amount of the asset to redeem.
    function redeem(address asset, uint256 amount) external;

    /// @notice Borrow function for borrowing assets from the Compound protocol.
    /// @param asset The address of the asset being borrowed (e.g., DAI).
    /// @param amount The amount of the asset to borrow.
    function borrow(address asset, uint256 amount) external;

    /// @notice Get the borrow rate for a specific asset in the Compound protocol.
    /// @param asset The address of the asset (e.g., DAI) for which the borrow rate is queried.
    /// @return borrowRate The borrow interest rate for the specified asset.
    function getBorrowRate(address asset) external view returns (uint256);
}
