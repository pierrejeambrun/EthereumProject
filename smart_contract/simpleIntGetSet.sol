pragma solidity ^0.4.0;

contract MessageContract {
    uint256 _x = 0;

    function getX() public constant returns(uint256) {
        return _x;
    }

    function setX(uint256 x) public {
        _x = x;
    }
}