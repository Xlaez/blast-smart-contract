// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.13;

import {Script, console} from "forge-std/Script.sol";
import {EthTransfer} from "../src/EthTransfer.sol";

contract DeployEthTransfer is Script {
    EthTransfer public ethTransfer;

    function setUp() public {}

    function run() external {
        // Start broadcasting transactions with private key
        vm.startBroadcast();

        // Deploy the EthTransfer contract
        ethTransfer = new EthTransfer();

        console.log("EthTransfer deloyed at:", address(ethTransfer));

        // Stop broadcasting
        vm.stopBroadcast();
    }
}
