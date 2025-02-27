// SPDX-License-Identifier: MIT
pragma solidity 0.8.21;

import {IAggregatorAdapter} from "./interfaces/IAggregatorAdapter.sol";
import "@openzeppelin/contracts/access/Ownable.sol";
import "@openzeppelin/contracts/security/ReentrancyGuard.sol";
import "@openzeppelin/contracts/token/ERC20/utils/SafeERC20.sol";
import "@openzeppelin/contracts/token/ERC20/IERC20.sol";

/// @title Lending Aggregator
/// @notice Aggregates lending across multiple protocols with optimized borrowing and supplying.
/// @dev This contract interacts with lending protocols, optimizing the rates for borrowing and supplying
/// assets by choosing the best protocol based on the given rates.
contract LendingAggregator is Ownable, ReentrancyGuard {
    using SafeERC20 for IERC20;

    // Treasury address for collecting fees
    address public treasury;

    // Constant for the fee percentage (0.2%)
    uint256 public constant FEE_PERCENT = 20; // 0.2% fee

    // Mapping to store adapters (lending protocols) by protocol ID
    mapping(uint256 => IAggregatorAdapter) public adapters;
    // Mapping to store protocol names by protocol ID
    mapping(uint256 => string) public protocolNames;
    /// Mappint to store users assets deposites
    mapping(address => mapping(address => uint256)) public userDepositProtocol;

    // Tracks the number of protocols added
    uint256 public protocolCount;

    // Event triggered when an adapter is updated
    event AdapterUpdated(uint256 protocolId, address adapter);

    /// @notice Constructor to initialize the treasury address.
    /// @param _treasury The address to collect fees.
    constructor(address _treasury) {
        treasury = _treasury;
        protocolCount = 0; // Initialize protocol count to 0
    }

    /// @notice Sets or updates an adapter for a lending protocol.
    /// @dev Only the owner can update the adapter.
    /// @param protocolId The ID of the protocol to update.
    /// @param adapter The address of the lending protocol adapter (contract).
    function setAdapter(uint256 protocolId, address adapter) external onlyOwner {
        adapters[protocolId] = IAggregatorAdapter(adapter);
        emit AdapterUpdated(protocolId, adapter);
    }

    /// @notice Get the best deposit rate and protocol for a given asset.
    /// @param asset The address of the asset to get the best deposit rate for.
    /// @return bestRate The highest deposit rate for the asset across protocols.
    /// @return bestProtocolId The ID of the protocol offering the best deposit rate.
    function getBestDepositRate(address asset) public view returns (uint256 bestRate, uint256 bestProtocolId) {
        bestRate = 0; // Initialize best rate to 0
        bestProtocolId = 0; // Initialize best protocol ID

        // Loop through all protocols to find the one with the highest deposit rate
        for (uint256 i = 0; i < protocolCount; i++) {
            (uint256 depositRate, ) = adapters[i].getRates(asset);
            if (depositRate > bestRate) {
                bestRate = depositRate;
                bestProtocolId = i;
            }
        }
    }

    /// @notice Get the best borrow rate and protocol for a given asset.
    /// @param asset The address of the asset to get the best borrow rate for.
    /// @return bestRate The lowest borrow rate for the asset across protocols.
    /// @return bestProtocolId The ID of the protocol offering the best borrow rate.
    function getBestBorrowRate(address asset) public view returns (uint256 bestRate, uint256 bestProtocolId) {
        bestRate = type(uint256).max; // Initialize best rate to maximum possible value
        bestProtocolId = 0; // Initialize best protocol ID

        // Loop through all protocols to find the one with the lowest borrow rate
        for (uint256 i = 0; i < protocolCount; i++) {
            (, uint256 borrowRate) = adapters[i].getRates(asset);
            if (borrowRate < bestRate) {
                bestRate = borrowRate;
                bestProtocolId = i;
            }
        }
    }

    /// @notice Deposit an asset into the best protocol based on deposit rate.
    /// @dev The function transfers the asset to the contract, then to the best protocol.
    /// @param asset The address of the asset to deposit.
    /// @param amount The amount of the asset to deposit.
    function deposit(address asset, uint256 amount) external nonReentrant {
        uint256 fee = (amount * FEE_PERCENT) / 10000; // Calculate fee (0.2%)
        uint256 netAmount = amount - fee; // Net amount after fee deduction

        // Transfer asset to the contract
        IERC20(asset).safeTransferFrom(msg.sender, address(this), amount);

        // Get the best protocol for deposit
        (uint256 bestRate, uint256 bestProtocolId) = getBestDepositRate(asset);
        userDepositProtocol[msg.sender][asset] = bestProtocolId; // Track protocol

        IAggregatorAdapter adapter = adapters[bestProtocolId];

        address protocolAddress = adapter.getProtocolAddress();
        IERC20(asset).approve(protocolAddress, netAmount);

        adapter.supply(asset, netAmount, msg.sender); // Supply to the best protocol

        // Transfer the fee to the treasury
        IERC20(asset).safeTransfer(treasury, fee);
    }

    /// @notice Withdraw an asset from the lending protocol.
    /// @dev This will call the `withdraw` function of each registered protocol.
    /// @param asset The address of the asset to withdraw.
    /// @param amount The amount of the asset to withdraw.
    function withdraw(address asset, uint256 amount) external nonReentrant {
        uint256 protocolId = userDepositProtocol[msg.sender][asset];

        require(protocolId < protocolCount, "Invalid protocol");
        IAggregatorAdapter adapter = adapters[protocolId];

        adapter.withdraw(asset, amount, msg.sender);
    }

    /// @notice Borrow an asset from the best protocol based on borrow rate.
    /// @dev The function borrows the asset from the best protocol and transfers the fee to the treasury.
    /// @param asset The address of the asset to borrow.
    /// @param amount The amount of the asset to borrow.
    function borrow(address asset, uint256 amount) external nonReentrant {
        uint256 fee = (amount * FEE_PERCENT) / 10000; // Calculate fee (0.2%)
        uint256 netAmount = amount + fee; // Total amount including the fee

        (uint256 bestRate, uint256 bestProtocolId) = getBestBorrowRate(asset);
        IAggregatorAdapter adapter = adapters[bestProtocolId];
        address protocolAddress = adapter.getProtocolAddress();

        // Approve protocol if needed (e.g., for collateral)
        adapter.borrow(asset, netAmount, msg.sender);

        IERC20(asset).safeTransfer(treasury, fee);
        IERC20(asset).safeTransfer(msg.sender, amount); // Send user the requested amount
    }

    /// @notice Add a new protocol to the aggregator.
    /// @dev Only the owner can add a protocol. New protocols are added by incrementing `protocolCount`.
    /// @param adapter The address of the lending protocol adapter (contract).
    /// @param name The name of the protocol to associate with the protocol ID.
    function addProtocol(address adapter, string calldata name) external onlyOwner {
        adapters[protocolCount] = IAggregatorAdapter(adapter); // Add the new adapter
        protocolNames[protocolCount] = name; // Store the protocol name
        protocolCount++; // Increment the protocol count
    }
}
