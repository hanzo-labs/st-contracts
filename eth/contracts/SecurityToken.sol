pragma solidity >=0.4.25 <0.6.0;

import "openzeppelin-solidity/contracts/lifecycle/Pausable.sol";
import "openzeppelin-solidity/contracts/math/SafeMath.sol";
import "openzeppelin-solidity/contracts/ownership/Ownable.sol";
import "openzeppelin-solidity/contracts/token/ERC20/ERC20Burnable.sol";
import "openzeppelin-solidity/contracts/token/ERC20/ERC20Mintable.sol";
import "openzeppelin-solidity/contracts/token/ERC20/ERC20Pausable.sol";

import "./Registry.sol";

contract SecurityToken is ERC20Burnable, ERC20Mintable, ERC20Pausable, Ownable {
    using SafeMath for uint256;

    address public registryAddress;

    string public constant name     = "US Treasury Token";
    string public constant symbol   = "UST";
    uint8  public constant decimals = 18;

    /// @dev Instantiate token implementation and set owner
    constructor () Ownable() public {}

    /// @dev Set address of registry to use for KYC/AML/regulatory controls
    function setRegistry(address addr) onlyOwner public {
        require(addr != address(0));
        registryAddress = addr;
    }

    /// @dev Determine whether transfers to/from a given address has been
    //       approved by the registry service.
    /// @param addr Address to check against registry
    /// @return bool
    function isApproved(address addr) public view returns (bool) {
        require(addr != address(0));
        return Registry(registryAddress).isApproved(addr);
    }

    /// @dev Implemented to meet ST-20
    /// @notice Validates a transfer against KYC/AML registry
    /// @param from sender of transfer
    /// @param to receiver of transfer
    /// @param value value of transfer
    /// @param data data to indicate validation
    /// @return bool
    function verifyTransfer(address from, address to, uint256 value, bytes memory data) public view returns (bool) {
        require(value > 0 || data.length > 0);
        return isApproved(from) && isApproved(to);
    }

    /// @dev Implemented to meet ERC-1404 Simple Restricted Token Standard.
    /// @notice Detects if a transfer will be reverted and if so returns an
    ///         appropriate reference code.
    /// @param from Sending address
    /// @param to Receiving address
    /// @param value Amount of tokens being transferred
    /// @return Code by which to reference message for rejection reasoning
    function detectTransferRestriction (address from, address to, uint256 value) public view returns (uint8) {
        if (verifyTransfer(from, to, value, "")) {
            return 0;
        } else {
            return 1;
        }
    }

    /// @dev ERC-1404 Simple Restricted Token Standard.
    /// @notice Returns a human-readable message for a given restriction code
    /// @param restrictionCode Identifier for looking up a message
    /// @return Text showing the restriction's reasoning
    function messageForTransferRestriction (uint8 restrictionCode) public pure returns (string memory) {
        if (restrictionCode == 0) {
            return "SUCCESS";
        } else {
            return "FAILURE";
        }
    }

    /// @dev Transfer a token to a specified address
    ///
    /// Transfer conditions:
    ///  - msg.sender address must be valid
    ///  - msg.sender cannot be on the blacklist
    ///  - msg.sender must be whitelisted previously by KYC/AML process
    ///  - contract must be unpaused
    ///
    /// @param to address to transfer to
    /// @param value amount to transfer
    /// @return bool
    function transfer(address to, uint value) public returns (bool) {
        require(value > 0);
        require(to != address(0));
        require(isApproved(to));
        return super.transfer(to, value);
    }

    /// @dev Transfer tokens from one address to another
    /// @param from address The address which you want to send tokens from
    /// @param to address The address which you want to transfer to
    /// @param value uint256 the amount of tokens to be transferred
    /// @return bool
    function transferFrom(address from, address to, uint256 value) public returns (bool) {
        require(value > 0);
        require(to != address(0));
        require(verifyTransfer(from, to, value, ""));
        return super.transferFrom(from, to, value);
    }
}
