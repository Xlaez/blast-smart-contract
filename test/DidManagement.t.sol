// test/DidManagement.t.sol
// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.13;

import "forge-std/Test.sol";
import "../src/DidManagement.sol";

contract DecentralizedIdentityTest is Test {
    DecentralizedIdentity did;

    function setUp() public {
        did = new DecentralizedIdentity();
    }

    function testCreateDID() public {
        did.createDID();
        address owner = did.getOwner(address(this));
        bool exists = did.doesDIDExist(address(this));
        assertEq(owner, address(this));
        assertTrue(exists);
    }

    function testAddAndGetClaim() public {
        did.createDID();
        bytes32 claimValue = keccak256(abi.encodePacked("TestClaimValue"));
        did.addClaim("age", claimValue);

        bytes32 storedClaim = did.getClaim(address(this), "age");
        assertEq(storedClaim, claimValue);
    }

    function testRevokedClaim() public {
        did.createDID();
        bytes32 claimValue = keccak256(abi.encodePacked("TestClaimValue"));
        did.addClaim("age", claimValue);
        did.revokeClaim("age");

        bytes32 storedClaim = did.getClaim(address(this), "age");
        assertEq(storedClaim, 0x0);
    }
}
