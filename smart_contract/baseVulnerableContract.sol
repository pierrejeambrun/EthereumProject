pragma solidity ^0.4.0;

/**********
 This is the base for a vulnerable contract as was HackParity.
 A contract, a library and a payable method that delegates call to the library any method that is not matched
 To use delegateCall, the library address must be hardcoded
***********/

contract vulnerableContract {
    address constant _library = 0xcafecafecafecafecafecafecafecafecafecafe;
  
    // gets called when no other function matches
    function() payable {
        //If I get sent some cash (wallet logic)
        if (msg.value > 0) {
            //Do something
        }
        
        //Error here in delegateCall, still trying to find what it is
        else if (msg.data.length > 0) {
            //Delegate call to some library
            _library.delegatecall(msg.data);
        }
    } 
}
