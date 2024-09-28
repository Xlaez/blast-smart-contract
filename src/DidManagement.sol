// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.13;

contract DecentralizedIdentity {
    struct DID {
        address owner;
        mapping(string => bytes32) claims; // Mapping to store claim types and their hashed values
        bool exists;
    }

    // Mapping of user addresses to their DIDs

    mapping(address => DID) private dids;

    event DIDCreated(address indexed owner);
    event ClaimAdded(address indexed owner, string claimType);
    event ClaimRevoked(address indexed owner, string claimType);

    // Create a new DID for the sender
    function createDID() external {
        require(!dids[msg.sender].exists, "DID already exists");

        // Initialize a new DID
        dids[msg.sender].owner = msg.sender;
        dids[msg.sender].exists = true;

        emit DIDCreated(msg.sender);
    }

    // Add a new claim to the DID
    function addClaim(string memory claimType, bytes32 claimValue) external {
        require(dids[msg.sender].exists, "DID does not exist");

        dids[msg.sender].claims[claimType] = claimValue;
        emit ClaimAdded(msg.sender, claimType);
    }

    // Revoke a claim from a DID
    function revokeClaim(string memory claimType) external {
        require(dids[msg.sender].exists, "DID does not exist");

        delete dids[msg.sender].claims[claimType];
        emit ClaimRevoked(msg.sender, claimType);
    }

    // Get a claim value for a given claim type
    function getClaim(address owner, string memory claimType) external view returns (bytes32) {
        require(dids[owner].exists, "DID does not exist");

        return dids[owner].claims[claimType];
    }

    // Get the DID owner
    function getOwner(address _user) external view returns (address) {
        require(dids[_user].exists, "DID does not exist");
        return dids[_user].owner;
    }

    // Check if DID exists
    function doesDIDExist(address _user) external view returns (bool) {
        return dids[_user].exists;
    }
}
