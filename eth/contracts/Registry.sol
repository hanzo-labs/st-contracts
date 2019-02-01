pragma solidity >=0.4.25 <0.6.0;

import "openzeppelin-solidity/contracts/ownership/Ownable.sol";
import "hanzo-solidity/contracts/Blacklist.sol";
import "hanzo-solidity/contracts/Whitelist.sol";

contract Registry is Ownable {
    Blacklist private blacklist;
    Whitelist private whitelist;

    event BlacklistAdded(address indexed addr);
    event BlacklistRemoved(address indexed addr);
    event WhitelistAdded(address indexed addr);
    event WhitelistRemoved(address indexed addr);

    constructor () public Ownable() {
        blacklist = new Blacklist();
        whitelist = new Whitelist();
    }

    function whitelistAdd(address addr) public onlyOwner returns (bool) {
        whitelist.add(addr);
        emit WhitelistAdded(addr);
        return true;
    }

    function whitelistRemove(address addr) public onlyOwner returns (bool) {
        whitelist.remove(addr);
        emit WhitelistRemoved(addr);
        return true;
    }

    function blacklistAdd(address addr) public onlyOwner returns (bool) {
        blacklist.add(addr);
        emit BlacklistAdded(addr);
        return true;
    }

    function blacklistRemove(address addr) public onlyOwner returns (bool) {
        blacklist.remove(addr);
        emit BlacklistRemoved(addr);
        return true;
    }

    function isApproved(address addr) public view returns (bool) {
        return whitelist.isListed(addr) && !blacklist.isListed(addr);
    }
}
