pragma solidity >=0.4.25 <0.6.0;

import "hanzo-solidity/contracts/Versioned.sol";

contract USTreasuryToken is Versioned {
    string public constant name     = "US Treasury Token";
    string public constant symbol   = "USTR";
    uint8  public constant decimals = 18;
}
