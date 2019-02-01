pragma solidity >=0.4.25 <0.6.0;

import "hanzo-solidity/contracts/Versioned.sol";
import "openzeppelin-solidity/contracts/ownership/Ownable.sol";


contract USTreasuryToken is Versioned {
    string public constant name     = "US Treasury Token";
    string public constant symbol   = "USTR";
    uint8  public constant decimals = 18;

    constructor (address initialVersion) Ownable() public {
        setVersion(Version(initialVersion));
    }
}
