pragma solidity ^0.4.0;

contract MessageContract {
    string _message = "Hello World !";

    function getMessage() public constant returns(string) {
        return _message;
    }

    /******
    In Solidity browser, you need to send your string between double quotes : "string"
    ******/
    function setMessage(string message) public {
        _message = message;
    }
}
