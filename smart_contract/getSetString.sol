pragma solidity ^0.4.0;

contract MessageContract {
    string _message = "Hello World !";

    function getMessage() public constant returns(string) {
        return _message;
    }

    function setMessage(string message) public {
        _message = message;
    }
}
