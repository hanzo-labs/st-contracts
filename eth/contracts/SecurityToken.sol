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
    string public constant symbol   = "USTR";
    uint8  public constant decimals = 18;

    /// @dev Instantiate token implementation and set owner
    constructor () Ownable() public {}

    /// @dev Set address of registry to use for KYC/AML/regulatory controls
    function setRegistry(address _registryAddress) public {
        require(_registryAddress != address(0));
        registryAddress = _registryAddress;
    }

    /// @dev Modifier to ensure contract is not paused and sender is approved
    /// by registry.
    modifier unpausedAndApproved() {
        require(
            isOwner() || !paused() && isApproved(msg.sender),
            "contract paused or sender is not in whitelist"
        );
        _;
    }

    /// @dev Determine whether a transfer is approved by registry service.
    /// @param addr Address to check against registry
    function isApproved(address addr) public view returns (bool) {
        require(addr != address(0));
        return Registry(registryAddress).isApproved(addr);
    }

    /// @dev Transfer a token to a specified address
    ///
    /// Transfer conditions:
    ///  - msg.sender address must be valid
    ///  - msg.sender cannot be on the blacklist
    ///  - msg.sender must be whitelisted previously by KYC/AML process
    ///  - contract must be unpaused
    ///
    /// @param _to address to transfer to
    /// @param _value amount to transfer
    function transfer(
        address _to,
        uint _value
    )
        public
        unpausedAndApproved()
        returns (bool)
    {
        require(_to != address(0));
        require(msg.sender != address(0));
        return super.transfer(_to, _value);
    }
}
