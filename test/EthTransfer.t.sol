// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.13;

import "forge-std/Test.sol";
import "../src/EthTransfer.sol";

contract EthTrasferTest is Test {
    EthTransfer ethtransfer;
    address payable recipient;

    //  setup function to deploy the contract
    function setUp() public {
        ethtransfer = new EthTransfer();
        recipient = payable(address(0xABCD));
    }

    function testReceivedEther() public {
        vm.deal(address(this), 1 ether);
        (bool success,) = address(ethtransfer).call{value: 1 ether}("");
        assertTrue(success);
        assertEq(address(ethtransfer).balance, 1 ether);
    }

    // Test for successful ether transfer
    function testTransferEther() public {
        vm.deal(address(ethtransfer), 1 ether); // Fund the contract
        ethtransfer.transferEther(recipient, 0.5 ether);
        assertEq(recipient.balance, 0.5 ether);
    }

    //  Test for failed ether transfer due to insufficient balance
    function testFailTransferEtherInsufficientBalance() public {
        ethtransfer.transferEther(recipient, 1 ether);
    }
}
