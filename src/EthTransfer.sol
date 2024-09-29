// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.13;

/**
 * @title EthTransfer
 * @dev A contract that allows the owner to transfer Ether from the contract to any recipient.
 */
contract EthTransfer {
    address payable public owner;

    /// @dev Set the deployer as the owner of the contract.
    constructor() {
        owner = payable(msg.sender);
    }

    /**
     * @notice Transfers a specified amount of Ether to a recipient.
     * @dev Only callable by the contract owner. Requires sufficient contract balance.
     * @param recipient The address to receive the Ether.
     * @param amount The amount of Ether (in wei) to transfer.
     */
    function transferEther(address payable recipient, uint256 amount) external {
        require(address(this).balance >= amount, "Insufficient wallet balance.");

        // Transfer th Ether to the recipient
        recipient.transfer(amount);
    }

    /**
     * @notice Function to receive Ether. msg.data must be empty.
     */
    receive() external payable {}

    /**
     * @notice Function to receive Ether when msg.data is not empty.
     */
    fallback() external payable {}
}
