pragma solidity ^0.4.0;

/**********
 This is the base for a vulnerable contract as was HackParity.
 A contract, a library and a payable method that delegates call to the library any method that is not matched
 To use delegateCall, the library address must be hardcoded
***********/

contract TestLibrary {
    event reached();
    
    function canIReachThis() public {
       reached();
       //return true;
    }
}

contract vulnerableContract {
    //Ici mettre l'adresse de la librairie minée au préalable
    address constant _library = 0x692a70d2e424a56d2c6c27aa97d1a86395877b3a;
    
    event yesItWasCalled();


    function getAddressLib() pure public returns (address) {
        return _library;    
    }
    
    // gets called when no other function matches
    function() payable public {
        //If I get sent some cash (wallet logic)
        if (msg.value > 0) {
            //Do something
        }
        
        //Error here in delegateCall, still trying to find what it is
        else if (msg.data.length > 0) {
            //Delegate call to some library
            yesItWasCalled();
            //Below commented is call to canIReachThis method of the librairy which fires an event
            //_library.delegatecall(keccak256("canIReachThis()"));
            _library.delegatecall(msg.data);
        }
    } 
}

/**********
 Intermediary created only for testing in solidity browser and the Javascript VM.
 Do not use in environments with blockchain running. For that use your console to send transactions.
***********/

contract intermediary {
    address constant _myContract = 0xdc04977a2078c8ffdf086d618d1f961b6c546222;
    
    function sendDataToPayable(string _data) public returns (bool) {
        _myContract.delegatecall(keccak256(_data));
    }
}
