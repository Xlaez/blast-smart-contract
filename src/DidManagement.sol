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
    event ClaimVerified(address indexed owner, string claimType);
    event AgeVerified(address indexed owner, bool isOver18);

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

    // Verify the claim by checking the provided data against the stored hash
    function verifyBirthDateHashedClaim(string memory claimType, bytes32 providedClaimHash, uint256 birthDate)
        external
    {
        require(dids[msg.sender].exists, "DID does not exist");

        // Recompute the hash based on the provided birthdate
        bytes32 recomputeHash = keccak256(abi.encodePacked(birthDate));

        // Ensure the recomputed hash matches the stored hash for this claimType
        require(recomputeHash == providedClaimHash, "Invalid Claim");

        emit ClaimVerified(msg.sender, claimType);
    }

    // Verify if the user is over 18 using a precomputed hashed birthdate difference
    function isuserAbove18(address user, uint256 currentDate) external view returns (bool) {
        require(dids[user].exists, "DID does not exist");

        // retrieve the stored birthdate hash
        bytes32 storedBirthDateHash = dids[user].claims["birthdate"];
        require(storedBirthDateHash != 0x0, "Birthdate has not been set by user");

        uint256 eighteenYearsInSeconds = 18 * 365 * 24 * 60 * 60;
        uint256 eighteenYearsAgo = currentDate - eighteenYearsInSeconds;

        bytes32 recomputedHash = keccak256(abi.encodePacked(eighteenYearsAgo));
        return recomputedHash == storedBirthDateHash;
    }

    function doesUserMeetAgeRequirement(address user, uint256 currentDate, int32 requiredAge)
        external
        view
        returns (bool)
    {
        require(dids[user].exists, "DID does not exist");

        // retrieve the stored birthdate hash
        bytes32 storedBirthDateHash = dids[user].claims["birthdate"];
        require(storedBirthDateHash != 0x0, "Birthdate has not been set by user");

        // We assume that the third party has verified the claim off-chain and provided the correct currentdate
        // The user's stored birthdate is already hashed and stored
        uint256 requiredYearsinSeconds = uint32(requiredAge) * 365 * 24 * 60 * 60;

        // Check if user meets the required age by comparing the current date and the stored birthdate hash
        if (currentDate - uint256(storedBirthDateHash) >= requiredYearsinSeconds) {
            return true;
        }

        return false;
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
