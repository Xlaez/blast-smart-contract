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

    // function testIsUserAbove18() public {
    //     did.createDID();
    //     bytes32 birthdateHash = keccak256(abi.encodePacked(uint256(1072915200))); // Unix timestamp for Jan 1, 2004

    //     did.addClaim("birthdate", birthdateHash);

    //     //  Fast forward to a date that would make the user over 18 years old
    //     uint256 currentDate = 1640995200; // Jan 1, 2022 (18 years old)
    //     bool result = did.isuserAbove18(address(this), currentDate);

    //     assertTrue(result);
    // }
}
